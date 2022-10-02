output "vm_public_ip" {
  description = "public IP of VM"
  value       = { for name, vm in oci_core_instance.vm : name => vm.public_ip if var.vms[name].public_resource }
}