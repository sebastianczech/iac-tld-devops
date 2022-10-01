variable "compartment_id" {
  description = "Compartment ID"
  type        = string
}

variable "networks" {
  description = "VCNs details"
  type = map(object({
    id            = string
    vcn_name      = string
    public_subnet = bool
    cidr_block    = string
    route_table   = string
    route_rules = map(object({
      target      = string
      destination = string
    }))
  }))
}
