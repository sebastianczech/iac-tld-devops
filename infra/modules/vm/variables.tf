variable "compartment_id" {
  description = "Compartment ID"
  type        = string
}

variable "subnet_id" {
  description = "ID of subnet in VCN"
  type        = string
}

variable "vm_name" {
  description = "Name of VM"
  type        = string
}

variable "public_resource" {
  description = "True if resource are public"
  default     = false
  type        = bool
}

variable "vm_id_rsa_pub" {
  description = "SSH public key"
  type        = string
  default     = null
}

variable "vm_instance_shape" {
  description = "Shape of instance"
  type        = string
  default     = "VM.Standard.A1.Flex"
}