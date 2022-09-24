package iac_tld_devops

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestOutputFromModuleNetwork(t *testing.T) {
	// given
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "module_network_integration_test/",
		Logger:       logger.Terratest,
		Upgrade:      true,
		Lock:         true,
		NoColor:      false,
	})
	defer terraform.Destroy(t, terraformOptions)

	// when
	terraform.InitAndApply(t, terraformOptions)
	subnetDemoPublicId := terraform.Output(t, terraformOptions, "subnet_demo_public_id")

	// then
	assert.NotEmpty(t, subnetDemoPublicId)
}
