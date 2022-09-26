module "network" {
  source = "./../../modules/network"

  compartment_id            = var.compartment_id
  vcn_cidr_block            = var.vcn_cidr_block
  subnet_private_cidr_block = var.subnet_private_cidr_block
  subnet_public_cidr_block  = var.subnet_public_cidr_block
  route_rules               = var.route_rules
  egress_security_rules     = var.egress_security_rules
  ingress_security_rules    = var.ingress_security_rules

  vcn_name            = "vcn-test"
  subnet_private_name = "subnet-test-private"
  subnet_public_name  = "subnet-test-public"
}
