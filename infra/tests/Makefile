auth:
	oci session authenticate --region eu-frankfurt-1 --profile-name iac-tld-devops

test:
	go test -v -timeout 30m -count=1

integration-test:
	go test -v -timeout 30m -count=1 module_network_integration_test.go

e2e-test:
	go test -v -timeout 30m -count=1 infra_e2e_test.go
