variable "compartment_id" {
  description = "Compartment ID"
  type        = string
}

variable "networks" {
  description = "VCNs details"
  type = map(object({
    id         = string
    cidr_block = string
  }))
}