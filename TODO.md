# ToDo

- [x] prepare slides with animated code
- [x] prepare new code to show examples with:
  - [x] validation for variable
  - [x] validation for lifecycle of resources 
- [x] split code into modules
- [x] prepare integration and e2e tests using terratest: https://terratest.gruntwork.io/examples/
- [x] adjust/extend e2e and integration tests
- [x] extend network module and prepare additional test for routes
- [x] prepare architecture diagram
- [x] create more complex infrastructure
  - [x] new diagram
  - [x] seperate modules for app and db
  - [x] extend module for network
  - [x] create vm private api
  - [x] adjust tests
  - [x] create dynamic routing gateway
- [x] fix integration tests
- [x] introduce variables as objects, where network contains subnets, routers, rules etc.
- [ ] prepare notes (speach)
- [ ] prepare branches for each step
- [ ] finish presentation (e.g. include more pictures, include code after each demo, include table with types of tests and tools to use)

# More ideas

- [ ] show optionals in terraform 1.3: https://www.hashicorp.com/blog/terraform-1-3-improves-extensibility-and-maintainability-of-terraform-modules
- [ ] as a test use checking if SSH port is opened: https://github.com/gruntwork-io/terratest/blob/master/test/terraform_ssh_password_example_test.go
- [ ] prepare example of test in kitchen-terraform: https://newcontext-oss.github.io/kitchen-terraform/tutorials/
- [ ] check terragrunt: https://terragrunt.gruntwork.io/docs/getting-started/quick-start/
- [ ] prepare example of test in conftest: https://www.conftest.dev/
- [ ] prepare example of integrate test using localstack: https://localstack.cloud/
