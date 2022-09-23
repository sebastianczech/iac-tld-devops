output "vm_public_api_ip" {
  description = "public IP of VM for public API"
  value       = oci_core_instance.vm_public_api.public_ip
}