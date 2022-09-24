package iac_tld_devops

import (
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestOutputFromModuleNetwork(t *testing.T) {
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
		Logger:                   logger.Terratest,
		Upgrade:                  true,
		Lock:                     true,
		NoColor:                  false,
		RetryableTerraformErrors: retryableTerraformErrors,
		MaxRetries:               3,
		TimeBetweenRetries:       5 * time.Second,
	})
	// defer terraform.Destroy(t, terraformOptions)

	// when
	terraform.InitAndApply(t, terraformOptions)
	vmPublicApiIp := terraform.Output(t, terraformOptions, "vm_public_api_ip")

	// then
	assert.NotEmpty(t, vmPublicApiIp)
}
