variable "compartment_id" {
  description = "Compartment ID"
  type        = string
}

variable "vms" {
  description = "VMs details"
  type = map(object({
    vm_name           = string
    vm_instance_shape = string # e.g. "VM.Standard.A1.Flex"
    vm_id_rsa_pub     = string
    public_resource   = bool
    subnet_id         = string
  }))
}
