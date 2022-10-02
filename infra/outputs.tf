output "vm_public_api_ip" {
  description = "public IP of VM for public API"
  value       = module.vm.vm_public_ip["public_api"]
}