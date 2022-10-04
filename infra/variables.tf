# OCI settings

variable "compartment_id" {
  description = "Compartment ID"
  type        = string
}

variable "region" {
  description = "OCI region"
  type        = string
}

# Profile used for OCI command line tool

variable "profile_name" {
  description = "OCI profile name"
  type        = string
}

# Variables used in variable set in Terrafor Cloud

# variable "tenancy_ocid" {
#   description = "Tenancy OCID"
#   type        = string
# }

# variable "user_ocid" {
#   description = "User OCID"
#   type        = string
# }

# variable "private_key" {
#   description = "Private key created while creating API token"
#   type        = string
# }

# variable "fingerprint" {
#   description = "Fingerprint for created API token"
#   type        = string
# }

# VM settings

variable "vm_id_rsa_pub" {
  description = "SSH public key"
  type        = string
}

variable "vm_instance_shape" {
  description = "Shape of instance"
  type        = string
  default     = "VM.Standard.A1.Flex"
}

variable "vm_private_api" {
  description = "Name of private API"
  type        = string
}

variable "vm_private_db" {
  description = "Name of private DB"
  type        = string
}

variable "vm_public_api" {
  description = "Name of public API"
  type        = string
}

# Network settings

variable "vcn_name_demo" {
  description = "Name of VCN for demo"
  type        = string
}

variable "vcn_name_internal" {
  description = "Name of VCN for internal services"
  type        = string
}

variable "vcn_cidr_block_demo" {
  description = "CIDR block for VCN demo"
  type        = string
}

variable "vcn_cidr_block_internal" {
  description = "CIDR block for VCN internal"
  type        = string
}

variable "subnet_private_cidr_block_demo" {
  description = "CIDR block for private subnet in VCN demo"
  type        = string
}

variable "subnet_public_cidr_block_demo" {
  description = "CIDR block for public subnet in VCN demo"
  type        = string
}

variable "subnet_private_cidr_block_internal" {
  description = "CIDR block for private subnet in VCN internal"
  type        = string
}

variable "route_rules_demo" {
  type = map(object({
    target      = string
    destination = string
  }))
  default = {}
}

variable "egress_security_rules_demo" {
  type    = list(map(string))
  default = []
}

variable "ingress_security_rules_demo" {
  type    = list(map(string))
  default = []
}

variable "route_rules_internal" {
  type = map(object({
    target      = string
    destination = string
  }))
  default = {}
}

variable "egress_security_rules_internal" {
  type    = list(map(string))
  default = []
}

variable "ingress_security_rules_internal" {
  type    = list(map(string))
  default = []
}