// Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.


provider oci {
  alias = "destination"
}

/*
 * Helper module to create file system.
 */

resource "oci_file_storage_file_system" "shared_storage" {
  provider = oci.destination
  #Required
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id

  #Optional
  display_name = var.file_system_display_name
}

/*
 * Helper module to create mount target for the file system.
*/

resource "oci_file_storage_mount_target" "mount_target" {
  #Required
  provider            = oci.destination
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  subnet_id           = var.private_subnet_id

  #Optional
  display_name = var.mount_target_display_name
}

data "oci_core_private_ip" "mount_target_private_ip" {
  provider = oci.destination
  #Required
  private_ip_id = oci_file_storage_mount_target.mount_target.private_ip_ids.0
}

/*
 * Helper module to setup export for the file system.
*/

# export set
resource "oci_file_storage_export_set" "export_set" {
  provider = oci.destination
  # Required
  mount_target_id = oci_file_storage_mount_target.mount_target.id

  # Optional
  display_name      = var.export_set_display_name
  max_fs_stat_bytes = var.max_byte
  max_fs_stat_files = var.max_files
}

# export 
resource "oci_file_storage_export" "export_fs_mt" {
  provider = oci.destination
  #Required
  export_set_id  = oci_file_storage_export_set.export_set.id
  file_system_id = oci_file_storage_file_system.shared_storage.id
  path           = var.export_path_fs_mt

  export_options {
    source                         = var.export_read_write_access_source
    access                         = "READ_WRITE"
    identity_squash                = "NONE"
    require_privileged_source_port = true
  }

  export_options {
    source                         = var.export_read_only_access_source
    access                         = "READ_ONLY"
    identity_squash                = "ALL"
    require_privileged_source_port = true
  }
}