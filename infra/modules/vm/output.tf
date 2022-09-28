output "vm_public_ip" {
  description = "public IP of VM"
  value       = var.public_resource ? oci_core_instance.vm.public_ip : null
}