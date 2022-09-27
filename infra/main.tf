module "network" {
  source = "./modules/network"

  compartment_id            = var.compartment_id
  vcn_cidr_block            = var.vcn_cidr_block
  subnet_private_cidr_block = var.subnet_private_cidr_block
  subnet_public_cidr_block  = var.subnet_public_cidr_block
  route_rules               = var.route_rules
  egress_security_rules     = var.egress_security_rules
  ingress_security_rules    = var.ingress_security_rules
}

module "app" {
  source = "./modules/app"

  compartment_id         = var.compartment_id
  subnet_demo_public_id  = module.network.subnet_demo_public_id
  subnet_demo_private_id = module.network.subnet_demo_private_id
  vm_id_rsa_pub          = var.vm_id_rsa_pub
  vm_instance_shape      = var.vm_instance_shape
}
