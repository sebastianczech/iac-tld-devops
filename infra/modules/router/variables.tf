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
}
