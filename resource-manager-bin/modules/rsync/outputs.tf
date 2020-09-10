output instance_ip {
  description = "the private ip of rsync instance"
  value       = oci_core_instance.rsync_server.private_ip
}