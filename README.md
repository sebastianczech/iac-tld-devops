# Build infrastructure as a code (IaC) using test-later development (TLD) method

## Presentation summary

Using test-driven development (TDD) approach in software development is broadly used in industry for many years. When we are talking about infrastructure, it's not as obvious and frequently used approach, but when we take a look on [pyramid of tests](https://www.hashicorp.com/blog/testing-hashicorp-terraform) and think about tools available for infrastructure as a code (IaC), then we can propose multiple approaches to do:
- unit tests using built-in tools available e.g. in Terraform like ``terraform fmt``, ``terraform validate`` or external programs like [conftest](https://www.conftest.dev/)
- contract tests using [validations for variables](https://www.terraform.io/language/values/variables), [lifecycle pre-conditions for resources](https://www.terraform.io/language/expressions/custom-conditions) or external tools like [kitchen-terraform](https://github.com/newcontext-oss/kitchen-terraform)
- integration tests using [``terratest``](https://terratest.gruntwork.io/), [``localstack``](https://localstack.cloud/) or other local / non-production environments
- end-to-end tests using also [``terratest``](https://terratest.gruntwork.io/)

As we have a lot of types of tests, we have also different approaches when and how to write them. In case of TDD there is common cycle - writing failing test (red phase), implementing code which causes that tests is succeeding (green phase) and adjusting code (refactor phase). For infrastructure sometimes it's very hard to write tests before implementation e.g. validation rule variable can be created after variable is defined, not before, that's why in many cases for IaC we can talk about test-later development (TLD) method.

## Links

* [Testing HashiCorp Terraform](https://www.hashicorp.com/blog/testing-hashicorp-terraform)
* [Test-Driven Development (TDD) for Infrastructure](https://www.hashicorp.com/resources/test-driven-development-tdd-for-infrastructure)
* [Testing Infrastructure as Code on Localhost](https://www.hashicorp.com/resources/testing-infrastructure-as-code-on-localhost)
* [Design by Contract in Terraform](https://betterprogramming.pub/design-by-contracts-in-terraform-63467a749c1a)
* [TDD vs TLD and what is the minimum code coverage needed](https://medium.com/swlh/tdd-vs-tld-and-what-is-the-minimum-code-coverage-needed-f380181d3400)

## Demo

### Architecture diagram

![Architecture diagram](design/architecture_diagram.png)

### Quickstart

1. Register and activate account in [Oracle Cloud](https://cloud.oracle.com/)
1. Register and activate account in [Terraform Cloud](https://app.terraform.io/)
1. Install prerequisites on local machine:
   1. [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
   1. [OCI](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm)
   2. [Go](https://go.dev/doc/install)
2. Clone repository:
   1. ``git clone https://github.com/sebastianczech/iac-tld-devops``
   2. ``cd iac-tld-devops``
3. Configure workspace and variables values in Terraform Cloud (e.g. in file ``infra/terraform.tfvars`` with value for variable ``compartment_id``)
4. Provision infrastructure:
   1. ``cd infra``
   2. ``make init``
   3. ``make check``
   4. ``make plan``
   5. ``make deploy``
   6. ``make destroy``
5. Check infrastructure:
   1. ``export COMPARTMENT_ID=`oci iam compartment list | jq '.data[0]["compartment-id"]' | tr -d '"'` && echo $COMPARTMENT_ID``
   2. ``oci compute instance list --compartment-id $COMPARTMENT_ID | jq '.data[]["display-name"]'``
   3. ``oci network vcn list --compartment-id $COMPARTMENT_ID | jq '.data[] | ."display-name" + ": " + ."cidr-block"'``
   4. ``oci network subnet list --compartment-id $COMPARTMENT_ID | jq '.data[] | ."display-name" + ": " + ."cidr-block"'``
   5. ``oci network security-list list --compartment-id $COMPARTMENT_ID | jq '.data[] | ."display-name" + ": " + ."egress-security-rules"[].description + " - " + ."egress-security-rules"[].destination'``
   6. ``oci network security-list list --compartment-id $COMPARTMENT_ID | jq '.data[] | ."display-name" + ": " + ."ingress-security-rules"[].description + " - " + ."ingress-security-rules"[].source'``
   7. ``oci network route-table list --compartment-id $COMPARTMENT_ID | jq '.data[] | ."display-name" + ": " + ."route-rules"[].destination'``
   8. ``oci network drg list --compartment-id $COMPARTMENT_ID | jq '.data[]."display-name"'``
6. Execute tests:
   1. ``cd tests``
   2. ``make auth``
   3. ``make test``
7. See slides:
   1. ``git clone https://github.com/sebastianczech/iac-tld-devops``
   2. ``open slides/index.html``
8. Play recordings:
   1. ``asciinema play records/step-1-unit-test-fmt.cast``
   2. ``asciinema play records/step-2-unit-test-validate.cast``
   3. ``asciinema play records/step-3-contract-test-wrong-ip.cast``
   4. ``asciinema play records/step-4-contract-test-wrong-routing.cast``
   5. ``asciinema play records/step-5-integration-test.cast``
   6. ``asciinema play records/step-6-e2e.cast``