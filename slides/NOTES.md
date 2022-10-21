# Notes - Build infrastructure as a code (IaC) using test-later development (TLD) method

Hi everyone. I'm Sebastian Czech and welcome on my presentation about building IaC using TLD method.

## Agenda

* test pyramid
* test later development
* examples and live demo

Today I want to:
- talk about test pyramid, describe test types
- explain what test later development is and
- do live demo, during which I will show practical examples of test listed in the agenda

## Test Pyramid

So let's start. In software development there are known and used classical test pyramid, inverted test pyramid or test diamond. For infrastracture classical test pyramid, similar to that presented on the picture, seems the best one.
Why ? I'm going to tell in a moment, but before let's take a look on types of tests, which are visible here.
What is the purpose of each type of tests ?

Unit tests answer questions: “Does my configuration contain correct metadata?”, "Were all required attributes for resources defined?".
Contract tests check "if expected input data (variables values) match what I think I should pass to it?", "e.g. if we defined variable to have IP address of the subnet as input value, do we check if we passed string value in correct format?".
Integration tests provide answer questions: “Does module create the resources successfully?”, "Is behaviour of the module correct?"
End to end tests are checking whole infrastructure. They answer the question, “Can someone use the infrastructure system successfully?”, "If I need to configure application, do I have everything what is required e.g. opened and working SSH port to execute Ansible playbook?"

Now when we know what is the purpose of every test type, it's easier to explain why classical test pyramid is the best for IaC ? Deploying infrastructure is time consuming, it costs money - as higher in test pyramid we are, then the cost (time and money) is higher.

Ok, I hope, that part is more or less clear and let's go to second slide and next question - when to do tests ? 

https://www.hashicorp.com/blog/testing-hashicorp-terraform

## Test-Later Development (TLD)

* write code
* refactor
* write tests

TLD is the first approach about which I'm going to speak. It's very straight forward method. 
We starting from writing code, which needs to work. When it's ready, we are refactor it, clean it, optimize it.
The last stage is preparing test, when code is ready and it's refactored.

If somebody asks - what is the reason to prepare test after writing code ? I have at least 2 answers:
- tests increase confidence, that what we are delivering works
- when in future other person will take our code and he or she will add / change something, then using that tests we can check if we haven't broken something

## Test-Driven Development (TDD)

* red - write failing test
* green - make the test pass
* blue - refactor

Other approach, TDD, is well-known and used in software development for many years. TDD is built from 3 phases - red, green and blue. The most characteristic for that method is how we start our work - from preparing test, which fails. Then we implement required feature in code to make tests passing. At the end we are refactoring code.
When we finish 1 cycle, then the next one starts. We have many iterations until we deliver working piece of code.

## Why you should use TLD for IaC

In my opinion there are few factors why TLD is better for IaC:
* development time, because there are no iterations
* learning curve, especially if people have ops background, what is very common in DevOps world
* increase productivity, because we focus at first on working code, not on tests
* code simplicity, because doing TDD and writing test at first has big impact how the code is designed

https://medium.com/swlh/tdd-vs-tld-and-what-is-the-minimum-code-coverage-needed-f380181d3400

## Architecture diagram for simple infrastructure used for demo

* It's enough about theory, let's go to demo section.
* Describe architecture (networks, routing, virtual machines)
* Tell about OCI that it's not so popular, but there is 1 reasone why I choose it - I will share it at the end

## Demo - unit testing

* Show failing terraform validate and fix it
  * terraform validate (add missing compartment)
* Show failing terraform fmt and fix it
  * terraform fmt -recursive -diff -check
  * terraform fmt -recursive

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
  * Terraform code to show how modules are executed
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

* Compare integration tests to testing classes and public methods, not attributes and private methods
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
  * talk about implemented test (show Go code)
  * show that in Oracle Cloud resources are being created

## Testing infrastructure - toolbox

* end-to-end tests:
  * Terratest
  * Ansible with assert module and JUnit callbacks
  * Selenium

## More about testing infrastructure

To summarize all shown examples - I hope, that after that demo we can see value, which test are adding and reasons why to create them.
If you are interested in that topic, here are some resources which I can propose to read or watch.

* Testing HashiCorp Terraform - blog post with test pyramid picture, which I presented at the beginning of the presentation
* Test-Driven Development (TDD) for Infrastructure - 1 of the 2 great presentation about testing infrastructure
* Testing Infrastructure as Code on Localhost - 2 of the 2 great presentation about testing infrastructure
* Design by Contract in Terraform - great article about understanding custom condition checks

## 3 key takeaways

* Test infrastructure code in order to increase confidence of the code which you are delivering
* Use tools delivered with Terraform out of the box
* Test behaviour of Terraform modules

## Presentation and code

* https://github.com/sebastianczech/iac-tld-devops - in first link you can find slides and code, which I presented
* https://github.com/sebastianczech/k8s-oci - 2dn and 3rd link are the answer why I like OCI. Both of them there are delivering code, which you can use to configure Kubernetes cluster, which you can use for free in Oracle Cloud
* https://github.com/sebastianczech/k8s-oci-tf-cloud
* https://registry.terraform.io/namespaces/sebastianczech - in last link to Terrraform Registry you can find modules, which I created in that respositories for configuring Kubernetes cluster