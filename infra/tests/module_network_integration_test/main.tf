module "network" {
  # Problem with dependant module resolution if the path is relative: https://github.com/hashicorp/terraform/issues/23333
  source = "github.com/sebastianczech/iac-tld-devops//infra/modules/network"
  # source = "./../../modules/network"

  compartment_id            = var.compartment_id
  vcn_cidr_block            = var.vcn_cidr_block
  subnet_private_cidr_block = var.subnet_private_cidr_block
  subnet_public_cidr_block  = var.subnet_public_cidr_block
  egress_security_rules     = var.egress_security_rules
  ingress_security_rules    = var.ingress_security_rules

  vcn_name            = "vcn-test"
  subnet_private_name = "subnet-test-private"
  subnet_public_name  = "subnet-test-public"
}

output "subnet_demo_public_id" {
  value = module.network.subnet_demo_public_id
}