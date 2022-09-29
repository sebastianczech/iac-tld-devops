resource "oci_core_vcn" "vcn" {
  cidr_block     = var.vcn_cidr_block
  compartment_id = var.compartment_id
  display_name   = var.vcn_name
}

resource "oci_core_subnet" "subnet_private" {
  count          = var.subnet_private_cidr_block != null ? 1 : 0
  cidr_block     = var.subnet_private_cidr_block
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = var.subnet_private_name
}

resource "oci_core_subnet" "subnet_public" {
  count          = var.subnet_public_cidr_block != null ? 1 : 0
  cidr_block     = var.subnet_public_cidr_block
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = var.subnet_public_name
}
