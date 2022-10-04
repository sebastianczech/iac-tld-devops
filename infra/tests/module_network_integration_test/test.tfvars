# auth in OCI using command: oci session authenticate --region eu-frankfurt-1 --profile-name iac-tld-devops
profile_name = "iac-tld-devops"
region       = "eu-frankfurt-1"

vcn_name = "vcn-test"

route_rules = {
  "default" = {
    destination = "0.0.0.0/0"
    target      = "InternetGateway"
  }
}

egress_security_rules = [
  {
    destination      = "0.0.0.0/0"
    protocol         = "all"
    destination_type = "CIDR_BLOCK"
    description      = "Allow all outgoing traffic"
  }
]

ingress_security_rules = [
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
    icmp_type   = 3
    icmp_code   = 4
  }
]
