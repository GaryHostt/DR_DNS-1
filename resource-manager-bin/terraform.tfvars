#Copyright © 2020, Oracle and/or its affiliates.
#The Universal Permissive License (UPL), Version 1.0
/*
 Any values that are set in this file can not be changed.
*/

# Compute shape for bastion server
bastion_server_shape = "VM.Standard2.1"

# Compute shape for Database server
db_system_shape = "VM.Standard2.2"

dr_vcn_cidr_block = "10.0.0.0/16"

vcn_cidr_block = "192.168.0.0/16"

app_server_shape = "VM.Standard2.2"

db_display_name = "ActiveDBSystem"

export_read_only_access_source = "0.0.0.0/0"

cron_schedule = "0 */12 * * *"

dr_cron_schedule = "#0 */12 * * *"

src_user_data = "data.template_file.bootstrap_src.rendered"

dst_user_data = "data.template_file.bootstrap_dst.rendered"

src_mount_path = "/home/opc/src_filestore"

snapshot_frequency = "*/60 * * * *"

dst_mount_path = "/home/opc/dst_filestore"

data_sync_frequency = "*/30 * * * *"

db_admin_password = "PPassw0rd##123"

