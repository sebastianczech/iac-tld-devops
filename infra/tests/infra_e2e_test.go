package iac_tld_devops

import (
	"io/ioutil"
	"log"
	"net"
	"os"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"golang.org/x/crypto/ssh"
)

func TestOutputAfterInfraDeployment(t *testing.T) {
	// given
	retryableTerraformErrors := map[string]string{
		// `terraform init` frequently fails in CI due to network issues accessing plugins. The reason is unknown, but
		// eventually these succeed after a few retries.
		".*unable to verify signature.*":             "Failed to retrieve plugin due to transient network error.",
		".*unable to verify checksum.*":              "Failed to retrieve plugin due to transient network error.",
		".*no provider exists with the given name.*": "Failed to retrieve plugin due to transient network error.",
		".*registry service is unreachable.*":        "Failed to retrieve plugin due to transient network error.",
		".*connection reset by peer.*":               "Failed to retrieve plugin due to transient network error.",
	}
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir:             "../",
		VarFiles:                 []string{"demo.tfvars"},
		Logger:                   logger.Terratest,
		Upgrade:                  true,
		Lock:                     true,
		NoColor:                  false,
		RetryableTerraformErrors: retryableTerraformErrors,
		MaxRetries:               3,
		TimeBetweenRetries:       5 * time.Second,
	})
	defer terraform.Destroy(t, terraformOptions)

	// when
	terraform.InitAndApply(t, terraformOptions)
	vmPublicApiIp := terraform.Output(t, terraformOptions, "vm_public_api_ip")
	vmHostName, sshError := checkSshConnection(vmPublicApiIp)

	// then
	assert.NotEmpty(t, vmPublicApiIp)
	assert.Empty(t, sshError)
	assert.Equal(t, "vm-public-api", vmHostName)
}

func checkSshConnection(ipAddress string) (string, error) {
	// wait after starting up machine
	time.Sleep(8 * time.Second)

	// ssh private key
	homeDir, err := os.UserHomeDir()
	serverAddress := ipAddress + ":22"
	if err != nil {
		log.Fatalf("Cannot get home dir: %v", err)
	}
	key, err := ioutil.ReadFile(homeDir + "/.ssh/id_rsa")
	if err != nil {
		log.Fatalf("Cannot read private key: %v", err)
	}
	signer, err := ssh.ParsePrivateKey(key)
	if err != nil {
		log.Fatalf("Cannot parse private key: %v", err)
	}

	// ssh config
	config := &ssh.ClientConfig{
		User: "ubuntu",
		Auth: []ssh.AuthMethod{
			ssh.PublicKeys(signer),
		},
		HostKeyCallback: func(hostname string, remote net.Addr, key ssh.PublicKey) error {
			return nil
		},
	}

	// connect to ssh server
	conn, err := ssh.Dial("tcp", serverAddress, config)
	if err != nil {
		log.Fatalf("Cannot connect to ssh server %v: %v", serverAddress, err)
	}
	defer conn.Close()

	// open session
	session, err := conn.NewSession()
	if err != nil {
		log.Fatalf("Cannot create session with %v: %v", serverAddress, err)
	}
	defer session.Close()

	// run command and get stdout and stderr
	output, err := session.CombinedOutput("hostname")

	// return output without newline and error message
	return strings.TrimSuffix(string(output), "\n"), err
}
