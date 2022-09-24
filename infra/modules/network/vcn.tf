resource "oci_core_vcn" "vcn_demo" {
  cidr_block     = var.vcn_cidr_block
  compartment_id = var.compartment_id
  display_name   = "vcn-demo"
}

resource "oci_core_subnet" "subnet_demo_private" {
  cidr_block     = var.subnet_private_cidr_block
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn_demo.id
  display_name   = "subnet-demo-private"
}

resource "oci_core_subnet" "subnet_demo_public" {
  cidr_block     = var.subnet_public_cidr_block
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn_demo.id
  display_name   = "subnet-demo-public"
}
