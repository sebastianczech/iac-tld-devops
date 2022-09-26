variable "compartment_id" {
  description = "Compartment ID"
  type        = string
}

variable "region" {
  description = "OCI region"
  type        = string
}

variable "profile_name" {
  description = "OCI profile name"
  type        = string
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