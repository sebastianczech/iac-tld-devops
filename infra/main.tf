module "network_demo" {
  source = "./modules/network"

  compartment_id            = var.compartment_id
  vcn_cidr_block            = var.vcn_cidr_block
  subnet_private_cidr_block = var.subnet_private_cidr_block
  subnet_public_cidr_block  = var.subnet_public_cidr_block
  route_rules               = var.route_rules
  egress_security_rules     = var.egress_security_rules
  ingress_security_rules    = var.ingress_security_rules
}

module "vm_public_api" {
  source = "./modules/vm"

  compartment_id    = var.compartment_id
  subnet_id         = module.network_demo.subnet_demo_public_id
  vm_name           = "vm-public-api"
  public_resource   = true
  vm_id_rsa_pub     = var.vm_id_rsa_pub
  vm_instance_shape = var.vm_instance_shape
}

module "vm_private_db" {
  source = "./modules/vm"

  compartment_id    = var.compartment_id
  subnet_id         = module.network_demo.subnet_demo_private_id
  vm_name           = "vm-private-db"
  public_resource   = false
  vm_instance_shape = var.vm_instance_shape
}
