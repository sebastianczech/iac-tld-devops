output "subnet_public_id" {
  value = { for name, subnet in oci_core_subnet.subnet_public : name => subnet.id }
}

output "subnet_private_id" {
  value = { for name, subnet in oci_core_subnet.subnet_private : name => subnet.id }
}

output "vcn_id" {
  value = { for name, vcn in oci_core_vcn.vcn : name => vcn.id }
}

output "route_table_id" {
  value = { for name, vcn in oci_core_vcn.vcn : name => vcn.default_route_table_id }
}
