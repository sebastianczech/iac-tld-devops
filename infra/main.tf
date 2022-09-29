module "network_demo" {
  source = "./modules/network"

  compartment_id            = var.compartment_id
  vcn_name                  = var.vcn_name_demo
  vcn_cidr_block            = var.vcn_cidr_block_demo
  subnet_private_cidr_block = var.subnet_private_cidr_block_demo
  subnet_public_cidr_block  = var.subnet_public_cidr_block_demo
  route_rules               = var.route_rules_demo
  egress_security_rules     = var.egress_security_rules_demo
  ingress_security_rules    = var.ingress_security_rules_demo
}

module "network_internal" {
  source = "./modules/network"

  compartment_id            = var.compartment_id
  vcn_name                  = var.vcn_name_internal
  vcn_cidr_block            = var.vcn_cidr_block_internal
  subnet_private_cidr_block = var.subnet_private_cidr_block_internal
  route_rules               = var.route_rules_internal
  egress_security_rules     = var.egress_security_rules_internal
  ingress_security_rules    = var.ingress_security_rules_internal
}

module "vm_public_api" {
  source = "./modules/vm"

  compartment_id    = var.compartment_id
  subnet_id         = module.network_demo.subnet_public_id
  vm_name           = var.vm_public_api
  public_resource   = true
  vm_id_rsa_pub     = var.vm_id_rsa_pub
  vm_instance_shape = var.vm_instance_shape
}

module "vm_private_db" {
  source = "./modules/vm"

  compartment_id    = var.compartment_id
  subnet_id         = module.network_demo.subnet_private_id
  vm_name           = var.vm_private_db
  public_resource   = false
  vm_id_rsa_pub     = var.vm_id_rsa_pub
  vm_instance_shape = var.vm_instance_shape
}

module "vm_private_api" {
  source = "./modules/vm"

  compartment_id    = var.compartment_id
  subnet_id         = module.network_internal.subnet_private_id
  vm_name           = var.vm_private_api
  public_resource   = false
  vm_id_rsa_pub     = var.vm_id_rsa_pub
  vm_instance_shape = var.vm_instance_shape
}