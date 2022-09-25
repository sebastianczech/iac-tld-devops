provider "oci" {
  region              = var.region
  auth                = "SecurityToken"
  config_file_profile = var.profile_name
}