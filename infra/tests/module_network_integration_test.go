package iac_tld_devops

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestOutputFromModuleNetwork(t *testing.T) {
	// given
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "module_network_integration_test/",
		VarFiles:     []string{"test.tfvars"},
		Vars: map[string]interface{}{
			"vcn_cidr_block":            "10.1.0.0/16",
			"subnet_public_cidr_block":  "10.1.1.0/24",
			"subnet_private_cidr_block": "10.1.2.0/24",
		},
		Logger:  logger.Terratest,
		Upgrade: true,
		Lock:    true,
		NoColor: false,
	})
	defer terraform.Destroy(t, terraformOptions)

	// when
	terraform.InitAndApply(t, terraformOptions)
	subnetDemoPublicId := terraform.Output(t, terraformOptions, "subnet_demo_public_id")

	// then
	assert.NotEmpty(t, subnetDemoPublicId)
}

func TestErrorWhileProvidingWrongCidrIpAddressForSubnet(t *testing.T) {
	// given
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "module_network_integration_test/",
		VarFiles:     []string{"test.tfvars"},
		Vars: map[string]interface{}{
			"vcn_cidr_block":            "10.1.0.0/36",
			"subnet_public_cidr_block":  "10.1.1.0/24",
			"subnet_private_cidr_block": "10.1.2.0/24",
		},
		Logger:  logger.Terratest,
		Upgrade: true,
		Lock:    true,
		NoColor: false,
	})
	expectedErrorMessage := "Invalid IPv4 CIDR block for VCN"

	// when
	if _, err := terraform.InitAndPlanE(t, terraformOptions); err != nil {
		// then
		assert.Error(t, err)
		errorMessage := fmt.Sprintf("%v", err)
		assert.True(t, strings.Contains(errorMessage, expectedErrorMessage))
	} else {
		// then
		t.Errorf("Expecting error: %s", expectedErrorMessage)
	}
}
