variable "compartment_id" {
  description = "Compartment ID"
  type        = string
}

variable "networks" {
  description = "Networks details"
  type = map(object({
    vcn_name                  = string
    vcn_cidr_block            = string
    subnet_private_cidr_block = string
    subnet_public_cidr_block  = string
    egress_security_rules     = list(map(string))
    ingress_security_rules    = list(map(string))
  }))
  # EGRESS VALIDATION
  validation {
    condition = alltrue([
      for network in var.networks : (length(network.egress_security_rules) > 0 && anytrue([for rule in network.egress_security_rules : rule["destination"] == "0.0.0.0/0"]))
    ])
    error_message = "At least 1 rule should be defined for 0.0.0.0/0 destination"
  }
  validation {
    condition = alltrue([
      for network in var.networks : (length(network.egress_security_rules) > 0 && alltrue([for rule in network.egress_security_rules : can(rule["protocol"])]))
    ])
    error_message = "Every item in the egress security rules has to contain procotol"
  }
  validation {
    condition = alltrue([
      for network in var.networks : (length(network.egress_security_rules) > 0 && alltrue([for rule in network.egress_security_rules : can(rule["destination"])]))
    ])
    error_message = "Every item in the egress security rules has to contain destination"
  }
  validation {
    condition = alltrue([
      for network in var.networks : (length(network.egress_security_rules) > 0 && alltrue([for rule in network.egress_security_rules : can(rule["destination_type"])]))
    ])
    error_message = "Every item in the egress security rules has to contain destination_type"
  }
  validation {
    condition = alltrue([
      for network in var.networks : (length(network.egress_security_rules) > 0 && alltrue([for rule in network.egress_security_rules : can(rule["description"])]))
    ])
    error_message = "Every item in the egress security rules has to contain description"
  }
  # INGRESS VALIDATION
  validation {
    condition = alltrue([
      for network in var.networks : (length(network.ingress_security_rules) > 0 && anytrue([for rule in network.ingress_security_rules : rule["source"] == "0.0.0.0/0"]))
    ])
    error_message = "At least 1 rule should be defined for 0.0.0.0/0 source"
  }
  validation {
    condition = alltrue([
      for network in var.networks : (length(network.ingress_security_rules) > 0 && alltrue([for rule in network.ingress_security_rules : can(rule["protocol"])]))
    ])
    error_message = "Every item in the ingress security rules has to contain procotol"
  }
  validation {
    condition = alltrue([
      for network in var.networks : (length(network.ingress_security_rules) > 0 && alltrue([for rule in network.ingress_security_rules : can(rule["source"])]))
    ])
    error_message = "Every item in the ingress security rules has to contain source"
  }
  validation {
    condition = alltrue([
      for network in var.networks : (length(network.ingress_security_rules) > 0 && alltrue([for rule in network.ingress_security_rules : can(rule["source_type"])]))
    ])
    error_message = "Every item in the ingress security rules has to contain source_type"
  }
  validation {
    condition = alltrue([
      for network in var.networks : (length(network.ingress_security_rules) > 0 && alltrue([for rule in network.ingress_security_rules : can(rule["description"])]))
    ])
    error_message = "Every item in the ingress security rules has to contain description"
  }
}
