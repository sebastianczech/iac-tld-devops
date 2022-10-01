resource "oci_core_drg" "dynamic_routing_gateway" {
  compartment_id = var.compartment_id
  display_name   = "dynamic-routing-gateway"
}

resource "oci_core_drg_attachment" "drg_attachment" {
  for_each     = var.networks
  drg_id       = oci_core_drg.dynamic_routing_gateway.id
  display_name = "drg-attachment-${each.key}"
  network_details {
    id   = each.value.id
    type = "VCN"
  }
}

data "oci_core_drg_route_table_route_rules" "drg_route_table_routes" {
  drg_route_table_id = oci_core_drg.dynamic_routing_gateway.default_drg_route_tables[0].vcn
  route_type         = "STATIC"
}

resource "oci_core_drg_route_table_route_rule" "drg_route_table_route_rule" {
  for_each                   = var.networks
  drg_route_table_id         = oci_core_drg.dynamic_routing_gateway.default_drg_route_tables[0].vcn
  destination                = each.value.cidr_block
  destination_type           = "CIDR_BLOCK"
  next_hop_drg_attachment_id = oci_core_drg_attachment.drg_attachment[each.key].id
}
