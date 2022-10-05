# Notes - Build infrastructure as a code (IaC) using test-later development (TLD) method

My name is Sebastian Czech and welcome on my presentation about building IaC using TLD method, during which I want to present my thoughts and ideas how to write and test code for cloud deployments.

## Agenda

* test pyramid
* test later development
* examples and live demo

On the lecture I want to focus on 3 things:
- describe test pyramid
- explain what test later development is
- and show practical examples using me code available on my GitHub profile

## Test Pyramid

In software development there are known and used tests pyramid similar to that which I present on the picture.
In that approach we have a lot of unit tests, then smaller amount of contract tests, integration tests and at the top - few end to end tests. 

What is the purpose of each type of tests ?
Unit tests verify individual resources and configurations for expected values. They answer for question: “Does my configuration or plan contain the correct metadata?” 
Contract tests check that a configuration using a Terraform module passes properly formatted inputs. They answer for question: “Does the expected input to the module match what I think I should pass to it?"
Integration tests check that a configuration using a Terraform module passes properly formatted inputs. They answer for question: “Does this module or configuration create the resources successfully?”
End to end tests are checking whole infrastructure. They answer the question, “Can someone use the infrastructure system successfully?”

Why this approach is the best for IaC ? Deploying infrastructure is time consuming, it's not so fast as unit tests or integration test in software development. As higher in test pyramid we are, then the cost (time and money) is higher.

As we know what types of tests we can have then next question is when to do tests ? 

https://www.hashicorp.com/blog/testing-hashicorp-terraform

## Test-Driven Development (TDD)

* red - write failing test
* green - make the test pass
* blue - refactor

There are many approaches how and when to do it. One of them is TDD, which is used in software development for longer time. TDD is built from 3 phases - red, green and blue. When we finish 1 cycle, then the next one starts.

## Test-Later Development (TLD)

* write code
* refactor
* write tests

TLD is similar approach, but without that cycles and without builting tests at the beginning. Test are written , when code is ready and it's refactored.

## Why you should use TLD for IaC

* development time, especially when requirements are not know. There are no iterations.
* learning curve, especially if people have ops background, what is very common in DevOps world
* increase productivity, because we focus at first on working code
* code simplicity, because doing TDD and writing test at first has big impact how the code is designed

https://medium.com/swlh/tdd-vs-tld-and-what-is-the-minimum-code-coverage-needed-f380181d3400

## Architecture diagram for simple infrastructure used for demo

* It's enough about theory, let's go to demo section.
* Describe architecture (networks, routing, virtual machines)
* Tell about OCI that it's not so popular, but there is 1 reasone why I choose it - I will share it at the end

## Demo - unit testing

* Show failing terraform fmt and fix it
  * terraform fmt -recursive -diff -check
  * terraform fmt -recursive
* Show failing terraform validate and fix it
  * terraform validate (add missing compartment)

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
  * Fix variable value in Terraform variables file
  * Start apply one more time
* While waiting for infrastructure, login to:
  * Oracle cloud to show instances and networks with details (routing, security)
* After infrastructure is ready, check connection via SSH to VM with public IP
  * Investigate reason why it's not working and show routing rules in Terraform variables file and Oracle Cloud
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
  * Fix settings in Terraform variables file
  * Run apply one more time
  * Check connection via SSH
* Start destroying infrastructure

## Demo - contract testing - resource lifecycle conditions

* Only show currently used lifecycle in infra/modules/vm/compute.tf:

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

## Testing infrastructure - toolbox

* contract tests:
  * validation for variables
  * lifecycle pre-conditions and post-conditions for resources

## Demo - integration tests - Terratest

* Compare to testing classes and public methods, not attributes and private methods
* Show Go code with tests infra/tests/module_network_integration_test.go
* Show infra code for tests in infra/tests/module_network_integration_test/main.tf
* Show Makefile
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

* https://github.com/sebastianczech/iac-tld-devops - slides and code
* https://github.com/sebastianczech/k8s-oci - 1 version of my code to configure infrastructure by Terraform and provision Kubernetes by Ansible
* https://github.com/sebastianczech/k8s-oci-tf-cloud - 2 version of my code to configure infrastructure by Terraform and provision Kubernetes by Terraform
* https://registry.terraform.io/namespaces/sebastianczech - modules, which helps to configure infrastructure and provision Kubernetes