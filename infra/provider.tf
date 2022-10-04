### Provider configuration to use with Terrafor Cloud
# provider "oci" {
#   tenancy_ocid = var.tenancy_ocid
#   user_ocid    = var.user_ocid
#   private_key  = var.private_key
#   fingerprint  = var.fingerprint
#   region       = var.region
# }

### Provider configuration to use with Terraform Open Source
provider "oci" {
  region              = var.region
  auth                = "SecurityToken"
  config_file_profile = var.profile_name
}