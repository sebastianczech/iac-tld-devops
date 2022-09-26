variable "compartment_id" {
  description = "Compartment ID"
  type        = string
}

variable "vcn_name" {
  description = "Name of VCN"
  type        = string
  default     = "vcn-demo"
}

variable "subnet_private_name" {
  description = "Name of private subnet"
  type        = string
  default     = "subnet-demo-private"
}

variable "subnet_public_name" {
  description = "Name of public subnet"
  type        = string
  default     = "subnet-demo-public"
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

variable "route_rules" {
  description = "Routes to put in main route table in VCN"
  type = map(object({
    a = string                # a required attribute
    b = optional(string)      # an optional attribute
    c = optional(number, 127) # an optional attribute with default value
  })
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