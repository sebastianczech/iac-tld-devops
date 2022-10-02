module "network" {
  source = "./modules/network"

  compartment_id = var.compartment_id
  networks = {
    "demo" : {
      vcn_name : var.vcn_name_demo,
      vcn_cidr_block : var.vcn_cidr_block_demo,
      subnet_private_cidr_block : var.subnet_private_cidr_block_demo,
      subnet_public_cidr_block : var.subnet_public_cidr_block_demo,
      egress_security_rules : var.egress_security_rules_demo,
      ingress_security_rules : var.ingress_security_rules_demo,
    },
    "internal" : {
      vcn_name : var.vcn_name_internal,
      vcn_cidr_block : var.vcn_cidr_block_internal,
      subnet_private_cidr_block : var.subnet_private_cidr_block_internal,
      subnet_public_cidr_block : null,
      egress_security_rules : var.egress_security_rules_internal,
      ingress_security_rules : var.ingress_security_rules_internal,
    }
  }
}

module "router" {
  source = "./modules/router"

  compartment_id = var.compartment_id
  networks = {
    "demo" : {
      id : module.network.vcn_id["demo"],
      vcn_name : var.vcn_name_demo,
      public_subnet : var.subnet_public_cidr_block_demo != null,
      route_rules : var.route_rules_demo,
      vcn_cidr_block : var.vcn_cidr_block_demo,
      route_table : module.network.route_table_id["demo"]
    },
    "internal" : {
      id : module.network.vcn_id["internal"],
      vcn_name : var.vcn_name_internal,
      public_subnet : false,
      route_rules : var.route_rules_internal,
      vcn_cidr_block : var.vcn_cidr_block_internal,
      route_table : module.network.route_table_id["internal"]
    }
  }
}

module "vm" {
  source = "./modules/vm"

  compartment_id = var.compartment_id
  vms = {
    "public_api" : {
      vm_name           = var.vm_public_api
      vm_instance_shape = var.vm_instance_shape
      vm_id_rsa_pub     = var.vm_id_rsa_pub
      public_resource   = true
      subnet_id         = module.network.subnet_public_id["demo"]
    },
    "private_db" : {
      vm_name           = var.vm_private_db
      vm_instance_shape = var.vm_instance_shape
      vm_id_rsa_pub     = var.vm_id_rsa_pub
      public_resource   = false
      subnet_id         = module.network.subnet_private_id["demo"]
    },
    "private_api" : {
      vm_name           = var.vm_private_api
      vm_instance_shape = var.vm_instance_shape
      vm_id_rsa_pub     = var.vm_id_rsa_pub
      public_resource   = false
      subnet_id         = module.network.subnet_private_id["internal"]
    }
  }
}
