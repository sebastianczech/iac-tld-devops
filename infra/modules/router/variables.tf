variable "compartment_id" {
  description = "Compartment ID"
  type        = string
}

variable "networks" {
  description = "Networks details"
  type = map(object({
    id             = string
    vcn_name       = string
    public_subnet  = bool
    vcn_cidr_block = string
    route_table    = string
    route_rules = map(object({
      target      = string
      destination = string
    }))
  }))
  validation {
    condition = alltrue([
      for network in var.networks : length(network.route_rules) > 0 && anytrue([for name, route_rule in network.route_rules : route_rule.destination == "0.0.0.0/0"])
    ])
    error_message = "At least 1 rule should be defined for 0.0.0.0/0 destination"
  }
}
