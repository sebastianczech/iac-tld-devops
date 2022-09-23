terraform {
  cloud {
    organization = "sebastianczech"

    workspaces {
      name = "iac-tld-devops"
    }
  }

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 4.94.0"
    }
  }
  required_version = "~> 1.3.0"
}
