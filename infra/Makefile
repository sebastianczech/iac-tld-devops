auth:
	oci session authenticate --region eu-frankfurt-1 --profile-name iac-tld-devops

init:
	terraform init --upgrade

check:
	terraform fmt -recursive
	terraform validate

plan:
	terraform plan -var-file demo.tfvars

deploy:
	terraform apply -var-file demo.tfvars -auto-approve

destroy:
	terraform apply -var-file demo.tfvars -auto-approve -destroy