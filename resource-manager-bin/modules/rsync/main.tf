// Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

/*
 * Create an server instance
 */

provider oci {
  alias = "destination"
}

locals {
  # extract key name from the keypath
  private_key = element(reverse(split("/", var.ssh_private_key_file)), 0)
}

resource oci_core_instance "rsync_server" {
  provider            = oci.destination
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  display_name        = var.display_name

  source_details {
    source_type = "image"
    source_id   = var.source_id
  }

  agent_config {
    is_management_disabled = true
    is_monitoring_disabled = true
  }

  shape = var.shape

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_file)
    user_data           = var.user_data
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = false

    nsg_ids = [
      var.ping_all_id
    ]
  }

  connection {
    type        = "ssh"
    host        = oci_core_instance.rsync_server.private_ip
    user        = "opc"
    private_key = file(var.ssh_private_key_file)

    bastion_host        = var.bastion_ip
    bastion_user        = "opc"
    bastion_private_key = file(var.ssh_private_key_file)
  }
}

resource "null_resource" "verify_cloud_init_src" {
  depends_on = [oci_core_instance.rsync_server]

  connection {
    type        = "ssh"
    host        = oci_core_instance.rsync_server.private_ip
    user        = "opc"
    private_key = file(var.ssh_private_key_file)

    bastion_host        = var.bastion_ip
    bastion_user        = "opc"
    bastion_private_key = file(var.ssh_private_key_file)
  }

  provisioner "file" {
    source      = "./assets/scripts/cloud_init_checker.sh"
    destination = "~/cloud_init_checker.sh"
  }

  # upload the SSH keys used to access mount point in primary region
  provisioner file {
    source      = var.ssh_private_key_file
    destination = ".ssh/${local.private_key}"
  }

  provisioner remote-exec {
    inline = [
      "chmod go-rwx .ssh/${local.private_key}",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sh -x ~/cloud_init_checker.sh",
      "echo 'finished cloud_init'",
      "sudo cat /etc/cron.d/fss_sync_up_snapshot",
      "sudo crontab -l",
      "echo 'finished'",
    ]
  }
}