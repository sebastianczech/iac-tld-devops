variable "compartment_id" {
  description = "Compartment ID"
  type        = string
}

variable "subnet_demo_public_id" {
  description = "ID of public subnet in VCN demo"
  type        = string
}

variable "vm_id_rsa_pub" {
  description = "SSH public key"
  type        = string
}

variable "vm_instance_shape" {
  description = "Shape of instance"
  type        = string
  default     = "VM.Standard.A1.Flex"
}