resource "oci_core_internet_gateway" "vcn_inet_gateway" {
  for_each       = { for name, network in var.networks : name => network if network.public_subnet }
  compartment_id = var.compartment_id
  vcn_id         = each.value.id
  enabled        = true
  display_name   = "${each.value.vcn_name}-inet-gateway"
}

resource "oci_core_default_route_table" "vcn_route_table" {
  for_each                   = var.networks
  manage_default_resource_id = each.value.route_table
  compartment_id             = var.compartment_id
  display_name               = "${each.value.vcn_name}-default-route-table"
  dynamic "route_rules" {
    for_each = { for name, route_rule in each.value.route_rules : name => route_rule if route_rule.target == "DynamicRoutingGateway" }
    iterator = route_rule
    content {
      network_entity_id = oci_core_drg.dynamic_routing_gateway.id
      destination       = route_rule.value.destination
      destination_type  = "CIDR_BLOCK"
    }
  }
  dynamic "route_rules" {
    for_each = { for name, route_rule in each.value.route_rules : name => route_rule if route_rule.target == "InternetGateway" && each.value.public_subnet }
    iterator = route_rule
    content {
      network_entity_id = oci_core_internet_gateway.vcn_inet_gateway[each.key].id
      destination       = route_rule.value.destination
      destination_type  = "CIDR_BLOCK"
    }
  }
}
