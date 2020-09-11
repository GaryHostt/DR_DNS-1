// Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# OCI Provider variables
variable "tenancy_ocid" {

}
variable "region" {

}

# Deployment variables
variable "compartment_ocid" {

}

variable "dr_region" {

}

variable "freeform_tags" {
  type        = map
  description = "map of freeform tags to apply to all resources"
  default = {
    "Environment" = "dr"
  }
}

variable "defined_tags" {
  type        = map
  description = "map of defined tags to apply to all resources"
  default     = {}
}

variable "dr_vcn_cidr_block" {
  type        = string
  description = "secondary vcn cidr block"
  default     = "10.0.0.0/16"
}

variable "vcn_cidr_block" {
  type        = string
  description = "primary vcn cidr block"
  default     = "192.168.0.0/16"
}

variable "vcn_dns_label" {
  description = "DNS label for Virtual Cloud Network (VCN)"
  default     = "drvcn"
}

variable "lb_display_name" {
  description = "display label for Load Balancer"
  default     = "dr_public_lb"
}

variable "is_private_lb" {
  description = "display label for Load Balancer"
  default     = "false"
}

variable "bucket_display_name" {
  description = "object storage Bucket Display name"
  default     = "bucket-dr"
}

variable "ssh_public_key_file" {
  type        = string
  description = "public ssh key string for all instances deployed in the environment"
}

variable "ssh_private_key_file" {
  type        = string
  description = "private ssh key string for all instances deployed in the environment"

}

variable bastion_server_shape {
  type        = string
  description = "oci shape for the instance"
  default     = "VM.Standard2.1"
}

variable "appserver_1_display_name" {
  type        = string
  description = "display name of app server1"
  default     = "app1"
}

variable "appserver_2_display_name" {
  type        = string
  description = "display name of app server2"
  default     = "app2"
}

variable "dst_fssserver_display_name" {
  type        = string
  description = "display name of destination server for fss replication"
  default     = "fss-replication"
}

variable app_server_shape {
  type        = string
  description = "oci shape for the instance"
  default     = "VM.Standard2.2"
}

variable "db_display_name" {
  type        = string
  description = "display name of database system"
  default     = "ActiveDBSystem"
}

variable "db_system_shape" {
  type        = string
  description = "shape of database instance"
  default     = "VM.Standard2.2"
}

variable "db_admin_password" {
  type        = string
  description = "password for SYS, SYSTEM, PDB Admin and TDE Wallet."
}

variable lb_shape {
  type        = string
  description = "a template that determines the total pre-provisioned bandwidth (ingress plus egress). Choose appropriate value based on the shapes available for the tenancy"
  default     = "100Mbps"
}

variable "export_read_only_access_source" {
  type        = string
  description = "clients these options should apply to. Must be a either single IPv4 address or single IPv4 CIDR block."
  default     = "0.0.0.0/0"
}

variable cron_schedule {
  type        = string
  description = "cron schedule. default runs every 12 hours"
  default     = "0 */12 * * *"
}

variable dr_cron_schedule {
  type        = string
  description = "cron schedule. default runs every 12 hours"
  default     = "#0 */12 * * *"
}

variable src_user_data {
  type        = string
  description = "userdata content"
  default     = "data.template_file.bootstrap_src.rendered"
}

variable dst_user_data {
  type        = string
  description = "userdata content"
  default     = "data.template_file.bootstrap_dst.rendered"
}

variable src_mount_path {
  type        = string
  description = "source mount path"
  default     = "/home/opc/src_filestore"
}

variable snapshot_frequency {
  type        = string
  description = "cron schedule. default runs every hour"
  default     = "*/60 * * * *"
}

variable dst_mount_path {
  type        = string
  description = "destination mount path"
  default     = "/home/opc/dst_filestore"
}

variable data_sync_frequency {
  type        = string
  description = "cron schedule. default runs every 30 minutes"
  default     = "*/30 * * * *"
}