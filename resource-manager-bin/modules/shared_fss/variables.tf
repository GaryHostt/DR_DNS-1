// Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable compartment_id {
  type        = string
  description = "compartment for the primary resources"
}

variable file_system_display_name {
  type        = string
  description = "display name of the file system"
  default     = "shared_storage"
}

variable availability_domain {
  type        = string
  description = "Controls whether the subnet is regional or specific to an availability domain."
}

variable "tenancy_ocid" {
  type        = string
  description = "tenancy ocid"
}

variable mount_target_display_name {
  type        = string
  description = "display name of the mount target"
  default     = "mount_target"
}

variable private_subnet_id {
  type        = string
  description = "subnet id for the mount target"
}

variable export_set_display_name {
  type        = string
  description = "display name of the mount target"
  default     = "export set for mount target"
}

variable "max_byte" {
  default     = 23843202333
  description = "max byte for export set"
}

variable "max_files" {
  default     = 223442
  description = "max files for export set"
}

variable "export_path_fs_mt" {
  default = "/shared"
}

variable "export_read_write_access_source" {
  type        = string
  description = "Clients these options should apply to. Must be a either single IPv4 address or single IPv4 CIDR block."
}

variable "export_read_only_access_source" {
  type        = string
  description = "Clients these options should apply to. Must be a either single IPv4 address or single IPv4 CIDR block."
}
