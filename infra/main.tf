resource "oci_core_vcn" "vcn_demo" {
  cidr_block     = var.vcn_cidr_block
  compartment_id = var.compartment_id
  display_name   = "vcn-demo"
}