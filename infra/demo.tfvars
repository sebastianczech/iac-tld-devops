# auth in OCI using command: oci session authenticate --region eu-frankfurt-1 --profile-name iac-tld-devops
profile_name = "iac-tld-devops"
region       = "eu-frankfurt-1"

vm_private_api = "vm-private-api"
vm_private_db  = "vm-private-db"
vm_public_api  = "vm-public-api"

vm_id_rsa_pub = null

vcn_name_demo     = "vcn-demo"
vcn_name_internal = "vcn-internal"

vcn_cidr_block_demo                = "10.1.0.0/16"
vcn_cidr_block_internal            = "10.2.0.0/16"
subnet_private_cidr_block_demo     = "10.1.2.0/24"
subnet_private_cidr_block_internal = "10.2.2.0/24"
subnet_public_cidr_block_demo      = "10.1.1.0/24"

route_rules_demo = {
  "drg" = {
    destination = "10.0.0.0/8"
    target      = "DynamicRoutingGateway"
  }
}

route_rules_internal = {
  "default" = {
    destination = "0.0.0.0/0"
    target      = "DynamicRoutingGateway"
  }
}

ingress_security_rules_demo = [
  {
    protocol    = 6
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Allow all for SSH"
    port        = 22
  },
  {
    protocol    = 6
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Allow all for HTTP"
    port        = 80
  },
  {
    protocol    = 6
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Allow all for HTTPS"
    port        = 443
  },
  {
    protocol    = 1
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Allow all for ICMP"
    icmp_type   = 8
    icmp_code   = 0
  }
]

ingress_security_rules_internal = [
  {
    protocol    = 6
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Allow all for SSH"
    port        = 22
  },
  {
    protocol    = 6
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Allow all for HTTP"
    port        = 80
  },
  {
    protocol    = 6
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Allow all for HTTPS"
    port        = 443
  },
  {
    protocol    = 1
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Allow all for ICMP"
    icmp_type   = 8
    icmp_code   = 0
  }
]

egress_security_rules_demo = [
  {
    destination      = "0.0.0.0/0"
    protocol         = "all"
    destination_type = "CIDR_BLOCK"
    description      = "Allow all outgoing traffic"
  }
]

egress_security_rules_internal = [
  {
    destination      = "0.0.0.0/0"
    protocol         = "all"
    destination_type = "CIDR_BLOCK"
    description      = "Allow all outgoing traffic"
  }
]
