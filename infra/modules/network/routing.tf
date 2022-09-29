resource "oci_core_internet_gateway" "vcn_inet_gateway" {
  count          = var.subnet_public_cidr_block != null ? 1 : 0
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  enabled        = true
  display_name   = "${var.vcn_name}-inet-gateway"
}

resource "oci_core_default_route_table" "vcn_route_table" {
  manage_default_resource_id = oci_core_vcn.vcn.default_route_table_id
  compartment_id             = var.compartment_id
  display_name               = "${var.vcn_name}-default-route-table"
  dynamic "route_rules" {
    for_each = { for name, route_rule in var.route_rules : name => route_rule if route_rule.target == "InternetGateway" && var.subnet_public_cidr_block != null }
    iterator = route_rule
    content {
      network_entity_id = oci_core_internet_gateway.vcn_inet_gateway[0].id
      destination       = route_rule.value.destination
      destination_type  = "CIDR_BLOCK"
    }
  }
}