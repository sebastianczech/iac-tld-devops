variable "tenancy_ocid" {
  description = "Tenancy OCID"
  type        = string
}

variable "compartment_id" {
  description = "Compartment ID"
  type        = string
}

variable "user_ocid" {
  description = "User OCID"
  type        = string
}

variable "private_key" {
  description = "Private key created while creating API token"
  type        = string
}

variable "fingerprint" {
  description = "Fingerprint for created API token"
  type        = string
}

variable "region" {
  description = "OCI region"
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

variable "vcn_cidr_block" {
  description = "CIDR block for VCN"
  type        = string
}

variable "subnet_private_cidr_block" {
  description = "CIDR block for private subnet"
  type        = string
}

variable "subnet_public_cidr_block" {
  description = "CIDR block for public subnet"
  type        = string
}

variable "route_rules" {
  type = map(object({
    target      = string
    destination = string
  }))
  default = {}
}

variable "egress_security_rules" {
  type    = list(map(string))
  default = []
}

variable "ingress_security_rules" {
  type    = list(map(string))
  default = []
}