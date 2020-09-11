// Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

terraform {
  required_version = ">= 0.12.0"
}

locals {
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name")
  image_id            = data.oci_core_images.oraclelinux.images.0.id

  dr_availability_domain = lookup(data.oci_identity_availability_domains.DR_ADs.availability_domains[0], "name")
  dr_image_id            = data.oci_core_images.DR_oraclelinux.images.0.id
}

data "template_file" "bootstrap_src" {
  template = file("./assets/templates/bootstrap_src.tpl")
  vars = {
    src_mount_path              = var.src_mount_path
    src_mount_target_private_ip = module.fss.dr_mount_target_ip
    src_export_path             = module.fss.dr_export_path
    snapshot_frequency          = var.snapshot_frequency
  }
}

data "template_file" "bootstrap_dst" {
  template = file("./assets/templates/bootstrap_dst.tpl")
  vars = {
    src_host                    = module.app_server_1.instance_ip
    src_mount_path              = var.src_mount_path
    dst_mount_path              = var.dst_mount_path
    dst_export_path             = module.dr_fss.dr_export_path
    dst_mount_target_private_ip = module.dr_fss.dr_mount_target_ip
    data_sync_frequency         = var.data_sync_frequency
  }
}

#############################################
### global resource provisioning         ####
#############################################
module iam {
  source = "./modules/iam"

  providers = {
    oci.destination = oci.home
  }

  compartment_id = var.compartment_ocid
  tenancy_ocid   = var.tenancy_ocid
  region_name    = var.region
}

#################################################
### destination region resource provisioning ####
#################################################
module dr_network {
  source = "./modules/network"

  providers = {
    oci.destination = oci.dr
  }

  tenancy_ocid          = var.tenancy_ocid
  compartment_id        = var.compartment_ocid
  vcn_name              = var.vcn_dns_label
  dns_label             = var.vcn_dns_label
  vcn_cidr_block        = var.dr_vcn_cidr_block
  remote_app_vcn_cidr   = var.vcn_cidr_block
  freeform_tags         = var.freeform_tags
  defined_tags          = var.defined_tags
  create_remote_peering = true

  remote_peering_connection_id               = null
  remote_peering_connection_peer_region_name = null
}

module dr_bastion_instance {
  source = "./modules/bastion_instance"

  providers = {
    oci.destination = oci.dr
  }

  tenancy_ocid        = var.tenancy_ocid
  compartment_id      = var.compartment_ocid
  source_id           = local.dr_image_id
  subnet_id           = module.dr_network.dr_access_subnet_id
  availability_domain = local.dr_availability_domain
  ping_all_id         = module.dr_network.dr_ping_all_id
  dr_region           = var.dr_region
  shape               = var.bastion_server_shape
  cron_schedule       = var.dr_cron_schedule

  ssh_public_key_file  = var.ssh_public_key_file
  ssh_private_key_file = var.ssh_private_key_file

  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags
}

module dr_app_server_1 {
  source = "./modules/server"

  providers = {
    oci.destination = oci.dr
  }

  tenancy_ocid        = var.tenancy_ocid
  compartment_id      = var.compartment_ocid
  source_id           = local.dr_image_id
  subnet_id           = module.dr_network.dr_app_subnet_id
  availability_domain = local.dr_availability_domain
  bastion_ip          = module.dr_bastion_instance.dr_instance_ip
  display_name        = var.appserver_1_display_name
  hostname_label      = var.appserver_1_display_name
  shape               = var.app_server_shape
  ping_all_id         = module.dr_network.dr_ping_all_id

  ssh_private_key_file = var.ssh_private_key_file
  ssh_public_key_file  = var.ssh_public_key_file
  user_data            = base64encode(data.template_file.bootstrap_src.rendered)
}

module dr_app_server_2 {
  source = "./modules/server"

  providers = {
    oci.destination = oci.dr
  }

  tenancy_ocid        = var.tenancy_ocid
  compartment_id      = var.compartment_ocid
  source_id           = local.dr_image_id
  subnet_id           = module.dr_network.dr_app_subnet_id
  availability_domain = local.dr_availability_domain
  bastion_ip          = module.dr_bastion_instance.dr_instance_ip
  display_name        = var.appserver_2_display_name
  hostname_label      = var.appserver_2_display_name
  shape               = var.app_server_shape
  ping_all_id         = module.dr_network.dr_ping_all_id

  ssh_private_key_file = var.ssh_private_key_file
  ssh_public_key_file  = var.ssh_public_key_file
}

module dr_public_lb {
  source = "./modules/lb"

  providers = {
    oci.destination = oci.dr
  }

  compartment_id       = var.compartment_ocid
  subnet_id            = module.dr_network.dr_lb_subnet_id
  display_name         = var.lb_display_name
  is_private           = var.is_private_lb
  shape                = var.lb_shape
  instance1_private_ip = module.dr_app_server_1.instance_ip
  instance2_private_ip = module.dr_app_server_2.instance_ip
  add_backend_set      = true
}

module dr_fss {
  source = "./modules/shared_fss"

  providers = {
    oci.destination = oci.dr
  }

  tenancy_ocid                    = var.tenancy_ocid
  compartment_id                  = var.compartment_ocid
  private_subnet_id               = module.dr_network.dr_app_subnet_id
  availability_domain             = local.dr_availability_domain
  export_read_write_access_source = var.dr_vcn_cidr_block
  export_read_only_access_source  = var.export_read_only_access_source
}

module dr_object {
  source = "./modules/object_storage"

  providers = {
    oci.destination = oci.dr
  }

  compartment_id = var.compartment_ocid
  display_name   = join("-", [var.dr_region, var.bucket_display_name])
}

#############################################
### primary region resource provisioning ####
#############################################
module network {
  source = "./modules/network"

  providers = {
    oci.destination = oci
  }

  tenancy_ocid        = var.tenancy_ocid
  compartment_id      = var.compartment_ocid
  vcn_name            = var.vcn_dns_label
  dns_label           = var.vcn_dns_label
  vcn_cidr_block      = var.vcn_cidr_block
  remote_app_vcn_cidr = var.dr_vcn_cidr_block
  freeform_tags       = var.freeform_tags
  defined_tags        = var.defined_tags

  create_remote_peering                      = false
  remote_peering_connection_id               = module.dr_network.dr_remote_peering_id
  remote_peering_connection_peer_region_name = var.dr_region
}

module bastion_instance {
  source = "./modules/bastion_instance"

  providers = {
    oci.destination = oci
  }

  tenancy_ocid        = var.tenancy_ocid
  compartment_id      = var.compartment_ocid
  source_id           = local.image_id
  subnet_id           = module.network.dr_access_subnet_id
  availability_domain = local.availability_domain
  ping_all_id         = module.network.dr_ping_all_id
  dr_region           = var.dr_region
  shape               = var.bastion_server_shape
  cron_schedule       = var.cron_schedule

  ssh_public_key_file  = var.ssh_public_key_file
  ssh_private_key_file = var.ssh_private_key_file

  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags
}

module fss {
  source = "./modules/shared_fss"

  providers = {
    oci.destination = oci
  }

  tenancy_ocid                    = var.tenancy_ocid
  compartment_id                  = var.compartment_ocid
  private_subnet_id               = module.network.dr_app_subnet_id
  availability_domain             = local.availability_domain
  export_read_write_access_source = var.vcn_cidr_block
  export_read_only_access_source  = var.export_read_only_access_source
}

module app_server_1 {
  source = "./modules/server"

  providers = {
    oci.destination = oci
  }

  tenancy_ocid        = var.tenancy_ocid
  compartment_id      = var.compartment_ocid
  source_id           = local.image_id
  subnet_id           = module.network.dr_app_subnet_id
  availability_domain = local.availability_domain
  bastion_ip          = module.bastion_instance.dr_instance_ip
  display_name        = var.appserver_1_display_name
  hostname_label      = var.appserver_1_display_name
  shape               = var.app_server_shape
  ping_all_id         = module.network.dr_ping_all_id

  ssh_private_key_file = var.ssh_private_key_file
  ssh_public_key_file  = var.ssh_public_key_file
  user_data            = base64encode(data.template_file.bootstrap_src.rendered)
}

module app_server_2 {
  source = "./modules/server"

  providers = {
    oci.destination = oci
  }

  tenancy_ocid        = var.tenancy_ocid
  compartment_id      = var.compartment_ocid
  source_id           = local.image_id
  subnet_id           = module.network.dr_app_subnet_id
  availability_domain = local.availability_domain
  bastion_ip          = module.bastion_instance.dr_instance_ip
  display_name        = var.appserver_2_display_name
  hostname_label      = var.appserver_2_display_name
  shape               = var.app_server_shape
  ping_all_id         = module.network.dr_ping_all_id

  ssh_private_key_file = var.ssh_private_key_file
  ssh_public_key_file  = var.ssh_public_key_file
}

module rsync_server {
  source = "./modules/rsync"

  providers = {
    oci.destination = oci.dr
  }

  tenancy_ocid        = var.tenancy_ocid
  compartment_id      = var.compartment_ocid
  source_id           = local.dr_image_id
  subnet_id           = module.dr_network.dr_app_subnet_id
  availability_domain = local.dr_availability_domain
  bastion_ip          = module.dr_bastion_instance.dr_instance_ip
  display_name        = var.dst_fssserver_display_name
  hostname_label      = var.dst_fssserver_display_name
  shape               = var.app_server_shape
  ping_all_id         = module.dr_network.dr_ping_all_id
  user_data           = base64encode(data.template_file.bootstrap_dst.rendered)

  ssh_private_key_file = var.ssh_private_key_file
  ssh_public_key_file  = var.ssh_public_key_file
}

module public_lb {
  source = "./modules/lb"

  compartment_id       = var.compartment_ocid
  subnet_id            = module.network.dr_lb_subnet_id
  display_name         = var.lb_display_name
  is_private           = var.is_private_lb
  shape                = var.lb_shape
  instance1_private_ip = module.app_server_1.instance_ip
  instance2_private_ip = module.app_server_2.instance_ip
  add_backend_set      = true
}

module object {
  source = "./modules/object_storage"

  providers = {
    oci.destination = oci
  }

  compartment_id          = var.compartment_ocid
  display_name            = join("-", [var.region, var.bucket_display_name])
  add_replication_policy  = true
  destination_bucket_name = module.dr_object.dr_bucket_name
  destination_region_name = var.dr_region
}


module database {
  source = "./modules/dbaas"

  providers = {
    oci.destination = oci
  }

  compartment_id      = var.compartment_ocid
  subnet_id           = module.network.dr_db_subnet_id
  availability_domain = local.availability_domain
  display_name        = var.db_display_name
  ping_all_id         = module.network.dr_ping_all_id
  ssh_public_keys     = var.ssh_public_key_file
  db_system_shape     = var.db_system_shape
  db_admin_password   = var.db_admin_password

  remote_subnet_id           = module.dr_network.dr_db_subnet_id
  remote_nsg_ids             = module.dr_network.dr_ping_all_id
  remote_availability_domain = local.dr_availability_domain
}