# Build infrastructure as a code (IaC) using test-later development (TLD) method

Using test-driven development (TDD) approach in software development is broadly used in industry for many years. When we are talking about infrastructure, it's not as obvious and frequently used approach, but when we take a look on [pyramid of tests](https://www.hashicorp.com/blog/testing-hashicorp-terraform) and think about tools available for infrastructure as a code (IaC), then we can propose multiple approaches to do:
- unit tests using built-in tools available e.g. in Terraform like ``terraform fmt``, ``terraform validate`` or external programs like [conftest](https://www.conftest.dev/)
- contract tests using [validations for variables](https://www.terraform.io/language/values/variables), [lifecycle pre-conditions for resources](https://www.terraform.io/language/expressions/custom-conditions) or external tools like [kitchen-terraform](https://github.com/newcontext-oss/kitchen-terraform)
- integration tests using [``terratest``](https://terratest.gruntwork.io/), [``localstack``](https://localstack.cloud/) or other local / non-production environments
- end-to-end tests using also [``terratest``](https://terratest.gruntwork.io/)

As we have a lot of types of tests, we have also different approaches when and how to write them. In case of TDD there is common cycle - writing failing test (red phase), implementing code which causes that tests is succeeding (green phase) and adjusting code (refactor phase). For infrastructure sometimes it's very hard to write tests before implementation e.g. validation rule variable can be created after variable is defined, not before, that's why in many cases for IaC we can talk about test-later development (TLD) method.
