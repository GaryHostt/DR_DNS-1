// Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

/*
 * Creates a bastion host instance and copies the provided public and private ssh keys
 * to the instance to access to the remove instances through the bastion
 */

provider oci {
  alias = "destination"
}

locals {
  # extract key name from the keypath
  private_key = element(reverse(split("/", var.ssh_private_key_file)), 0)
  public_key  = element(reverse(split("/", var.ssh_public_key_file)), 0)
}

resource oci_core_instance bastion_server {
  provider            = oci.destination
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  display_name        = var.display_name

  source_details {
    source_type = "image"
    source_id   = var.source_id
  }

  shape = var.shape

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_file)
    user_data = "${base64encode(file("./assets/scripts/yum-update.sh"))}"
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = true
    hostname_label   = var.hostname_label
    defined_tags     = var.defined_tags
    freeform_tags    = var.freeform_tags

    nsg_ids = [
      var.ping_all_id
    ]
  }

  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags

  connection {
    type        = "ssh"
    host        = oci_core_instance.bastion_server.public_ip
    user        = "opc"
    private_key = file(var.ssh_private_key_file)
  }

  provisioner file {
    source      = var.ssh_private_key_file
    destination = ".ssh/${local.private_key}"
  }

  provisioner file {
    source      = var.ssh_public_key_file
    destination = ".ssh/${local.public_key}"
  }

  # copy python script files to remote host
  provisioner "file" {
    source      = "./assets/scripts/block-volume-migration.py"
    destination = "/home/opc/block-volume-migration.py"
  }

  # copy python script files to remote host
  provisioner "file" {
    source      = "./assets/scripts/boot-volume-migration.py"
    destination = "/home/opc/boot-volume-migration.py"
  }

  provisioner remote-exec {
    inline = [
      "chmod go-rwx .ssh/${local.private_key}",
    ]
  }

  provisioner remote-exec {
    inline = [
      "sudo chmod +x /home/opc/boot-volume-migration.py",
      "sudo chmod +x /home/opc/block-volume-migration.py",
      "echo '${var.cron_schedule} python3 /home/opc/boot-volume-migration.py --compartment-id ${var.compartment_id} --destination-region ${var.dr_region} >> /home/opc/cron_bootvolume_log.log' | sudo tee -a /var/spool/cron/opc",
      "echo '${var.cron_schedule} python3 /home/opc/block-volume-migration.py --compartment-id ${var.compartment_id} --destination-region ${var.dr_region} >> /home/opc/cron_blockvolume_log.log' | sudo tee -a /var/spool/cron/opc",
    ]
  }
}