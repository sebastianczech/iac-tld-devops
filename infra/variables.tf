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

variable "vcn_cidr_block" {
  description = "CIDR block for VCN"
  type        = string
  validation {
    condition     = can(cidrnetmask(var.vcn_cidr_block))
    error_message = "Invalid IPv4 CIDR block for VCN"
  }
}

variable "subnet_private_cidr_block" {
  description = "CIDR block for private subnet"
  type        = string
  validation {
    condition     = can(cidrnetmask(var.subnet_private_cidr_block))
    error_message = "Invalid IPv4 CIDR block for subnet private"
  }
}

variable "subnet_public_cidr_block" {
  description = "CIDR block for public subnet"
  type        = string
  validation {
    condition     = can(cidrnetmask(var.subnet_public_cidr_block))
    error_message = "Invalid IPv4 CIDR block for subnet public"
  }
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
