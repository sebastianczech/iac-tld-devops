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

variable "egress_security_rules" {
  type    = list(map(string))
  default = []
  validation {
    condition     = (length(var.egress_security_rules) > 0 && anytrue([for rule in var.egress_security_rules : rule["destination"] == "0.0.0.0/0"]))
    error_message = "At least 1 rule should be defined for 0.0.0.0/0 destination"
  }
  validation {
    condition     = (length(var.egress_security_rules) > 0 && alltrue([for rule in var.egress_security_rules : can(rule["protocol"])]))
    error_message = "Every item in the egress security rules has to contain procotol"
  }
  validation {
    condition     = (length(var.egress_security_rules) > 0 && alltrue([for rule in var.egress_security_rules : can(rule["destination"])]))
    error_message = "Every item in the egress security rules has to contain destination"
  }
  validation {
    condition     = (length(var.egress_security_rules) > 0 && alltrue([for rule in var.egress_security_rules : can(rule["destination_type"])]))
    error_message = "Every item in the egress security rules has to contain destination_type"
  }
  validation {
    condition     = (length(var.egress_security_rules) > 0 && alltrue([for rule in var.egress_security_rules : can(rule["description"])]))
    error_message = "Every item in the egress security rules has to contain description"
  }
}

variable "ingress_security_rules" {
  type    = list(map(string))
  default = []
  validation {
    condition     = (length(var.ingress_security_rules) > 0 && anytrue([for rule in var.ingress_security_rules : rule["source"] == "0.0.0.0/0"]))
    error_message = "At least 1 rule should be defined for 0.0.0.0/0 source"
  }
  validation {
    condition     = (length(var.ingress_security_rules) > 0 && alltrue([for rule in var.ingress_security_rules : can(rule["protocol"])]))
    error_message = "Every item in the ingress security rules has to contain procotol"
  }
  validation {
    condition     = (length(var.ingress_security_rules) > 0 && alltrue([for rule in var.ingress_security_rules : can(rule["source"])]))
    error_message = "Every item in the ingress security rules has to contain source"
  }
  validation {
    condition     = (length(var.ingress_security_rules) > 0 && alltrue([for rule in var.ingress_security_rules : can(rule["source_type"])]))
    error_message = "Every item in the ingress security rules has to contain source_type"
  }
  validation {
    condition     = (length(var.ingress_security_rules) > 0 && alltrue([for rule in var.ingress_security_rules : can(rule["description"])]))
    error_message = "Every item in the ingress security rules has to contain description"
  }
}