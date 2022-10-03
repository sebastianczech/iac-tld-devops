# Notes - Build infrastructure as a code (IaC) using test-later development (TLD) method

## Agenda

* test pyramid
* test later development
* examples and live demo

## Test Pyramid

https://www.hashicorp.com/blog/testing-hashicorp-terraform

## Test-Driven Development (TDD)

* red - write failing test
* green - make the test pass
* blue - refactor

## Test-Later Development (TLD)

* write code
* refactor
* write tests

## Why you should use TLD for IaC

* development time
* learning curve
* increase productivity
* code simplicity

https://medium.com/swlh/tdd-vs-tld-and-what-is-the-minimum-code-coverage-needed-f380181d3400

## Architecture diagram for simple infrastructure used for demo

* Describe architecture (networks, routing, virtual machines)
* Tell about OCI that it's not so popular, but there is 1 reasone why I choose it - I will share it at the end

## Demo - unit testing

* Show failing terraform fmt and fix it
* Show failing terraform validate and fix it
  
## Testing infrastructure - toolbox

* unit tests: 
  * terraform fmt
  * terraform validate

## Demo - contract testing - variables validation

* Plan and apply infrastructure
* Issue when we use wrong IP address for VCN internal
  * Show the plan is working OK
  * Show the apply is failing
  * Investigate issue and add variable validation in infra/modules/network/variables.tf:

```
  validation {
    condition = alltrue([
      for network in var.networks : can(cidrnetmask(network.vcn_cidr_block))
    ])
    error_message = "Invalid IPv4 CIDR block for VCN"
  }
```

  * Show the plan is failing
  * Fix variable value in Terraform cloud
  * Start apply one more time
* While waiting for infrastructure, login to:
  * Terraform cloud to show settings (variables)
  * Oracle cloud to show instances and networks with details (routing, security)
* After infrastructure is ready, check connection via SSH to VM with public IP
  * Investigate reason why it's not working and show routing rules in Terraform Cloud and Oracle Cloud
  * Add variable validation to check default route in infra/modules/router/variables.tf:

```
  validation {
    condition = alltrue([
      for network in var.networks : length(network.route_rules) > 0 && anytrue([for name, route_rule in network.route_rules : route_rule.destination == "0.0.0.0/0"])
    ])
    error_message = "At least 1 rule should be defined for 0.0.0.0/0 destination"
  }
```

  * Run plan and show the error message
  * Fix settings in Terraform Cloud
  * Run apply one more time
  * Check connection via SSH

## Demo - contract testing - resource lifecycle conditions

* Show currently used lifecycle in infra/modules/vm/compute.tf:

```
  lifecycle {
    precondition {
      condition     = local.instance_firmware == "UEFI_64"
      error_message = "Use firmware compatible with 64 bit operating systems"
    }
    precondition {
      condition     = timecmp(local.image_time_created, timeadd(timestamp(), "-1440h")) > 0
      error_message = "VM image is older than 60 days"
    }
  }
```

* Change values and run plan to show that it's failing
* Restore previous values

## Testing infrastructure - toolbox

* contract tests:
  * validation for variables
  * lifecycle pre-conditions and post-conditions for resources

## Demo - integration tests - Terratest

* Start destroying infrastructure
* Show Go code with tests infra/tests/module_network_integration_test.go
* Show infra code for tests in infra/tests/module_network_integration_test/main.tf
* Show Makefile
* Auth in Oracle Cloud
* Improve tests by checking behaviour of our model:

```go
	// when
	terraform.InitAndApply(t, terraformOptions)
	subnetPublicId := terraform.Output(t, terraformOptions, "subnet_public_id")

	// then
	assert.NotEmpty(t, subnetPublicId)
```

* Improve tests by checkign error handling:

```go
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
```

* Execute integration tests

## Testing infrastructure - toolbox

* integration tests:
  * Terratest
  * kitchen-terraform

## Demo - end-to-end tests

* Start end-to-end tests and while waiting for infrastructure:
  * talk about implemented test
  * show that in Oracle Cloud resources are being created

## Testing infrastructure - toolbox

* end-to-end tests:
  * Terratest
  * Ansible with assert module and JUnit callbacks
  * Selenium

## More about testing infrastructure

* Testing HashiCorp Terraform - blog post with test pyramid picture, which I presented at the beginning of the presentation
* Test-Driven Development (TDD) for Infrastructure - 1 of the 2 great presentation about testing infrastructure
* Testing Infrastructure as Code on Localhost - 2 of the 2 great presentation about testing infrastructure
* Design by Contract in Terraform - great article about understanding custom condition checks

## 3 key takeaways

* Test infrastructure code in order to increase confidence of the product which you are delivering
* Use tools delivered with Terraform out of the box
* Test behaviour of Terraform modules

## Presentation and code

* https://github.com/sebastianczech/iac-tld-devops
* https://github.com/sebastianczech/k8s-oci
* https://github.com/sebastianczech/k8s-oci-tf-cloud
* https://registry.terraform.io/namespaces/sebastianczech