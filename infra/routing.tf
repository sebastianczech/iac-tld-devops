resource "oci_core_internet_gateway" "vcn_demo_inet_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn_demo.id
  enabled        = true
  display_name   = "vcn-demo-inet-gateway"
}

resource "oci_core_default_route_table" "vcn_demo_route_table_with_drg" {
  manage_default_resource_id = oci_core_vcn.vcn_demo.default_route_table_id
  compartment_id             = var.compartment_id
  display_name               = "vcn-demo-default-route-table"
  route_rules {
    network_entity_id = oci_core_internet_gateway.vcn_demo_inet_gateway.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}