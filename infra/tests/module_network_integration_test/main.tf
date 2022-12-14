module "network" {
  source = "./../../modules/network"

  compartment_id = var.compartment_id
  networks = {
    "test" : {
      vcn_name : var.vcn_name,
      vcn_cidr_block : var.vcn_cidr_block,
      subnet_private_cidr_block : var.subnet_private_cidr_block,
      subnet_public_cidr_block : var.subnet_public_cidr_block,
      egress_security_rules : var.egress_security_rules,
      ingress_security_rules : var.ingress_security_rules,
    }
  }
}
