// Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output dr_mount_target_ip {
  description = "private ip address of `oci_file_storage_mount_target` resource"
  value       = data.oci_core_private_ip.mount_target_private_ip.ip_address
}

output dr_export_path {
  description = "Path used to access the associated file system."
  value       = oci_file_storage_export.export_fs_mt.path
}