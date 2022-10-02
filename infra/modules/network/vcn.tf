resource "oci_core_vcn" "vcn" {
  for_each       = var.networks
  cidr_block     = each.value.vcn_cidr_block
  compartment_id = var.compartment_id
  display_name   = each.value.vcn_name
}

resource "oci_core_subnet" "subnet_private" {
  for_each       = { for name, network in var.networks : name => network if network.subnet_private_cidr_block != null }
  cidr_block     = each.value.subnet_private_cidr_block
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn[each.key].id
  display_name   = "${each.value.vcn_name}-subnet-private"
}

resource "oci_core_subnet" "subnet_public" {
  for_each       = { for name, network in var.networks : name => network if network.subnet_public_cidr_block != null }
  cidr_block     = each.value.subnet_public_cidr_block
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn[each.key].id
  display_name   = "${each.value.vcn_name}-subnet-public"
}
