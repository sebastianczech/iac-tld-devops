data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

data "oci_core_images" "oci_ubuntu_images" {
  compartment_id = var.compartment_id
  sort_by        = "TIMECREATED"
  sort_order     = "DESC"
  filter {
    name   = "operating_system"
    values = ["Canonical Ubuntu"]
  }
  filter {
    name   = "operating_system_version"
    values = ["20.04"]
  }
  filter {
    name   = "display_name"
    values = [".*aarch64.*"]
    regex  = true
  }
}

locals {
  instance_image    = data.oci_core_images.oci_ubuntu_images.images[0].id
  instance_firmware = data.oci_core_images.oci_ubuntu_images.images[0].launch_options[0].firmware
}

resource "oci_core_instance" "vm_public_api" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_id
  shape               = var.vm_instance_shape
  source_details {
    source_id   = local.instance_image
    source_type = "image"
  }
  display_name = "vm-public-api"
  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.subnet_demo_public.id
  }
  metadata = {
    ssh_authorized_keys = var.vm_id_rsa_pub
  }
  shape_config {
    baseline_ocpu_utilization = "BASELINE_1_1"
    memory_in_gbs             = 6
    ocpus                     = 1
  }
  preserve_boot_volume = false
  lifecycle {
    precondition {
      condition     = local.instance_firmware == "UEFI_64"
      error_message = "Use firmware compatible with 64 bit operating systems"
    }
  }
}
