output "subnet_public_id" {
  value = try(oci_core_subnet.subnet_public[0].id, null)
}

output "subnet_private_id" {
  value = try(oci_core_subnet.subnet_private[0].id, null)
}