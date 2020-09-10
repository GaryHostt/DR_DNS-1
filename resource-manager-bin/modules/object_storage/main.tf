
provider oci {
  alias = "destination"
}

/*
 * Provision Object Storage
 */

data "oci_objectstorage_namespace" "ns" {
  provider = oci.destination
  #Optional
  compartment_id = var.compartment_id
}

resource "oci_objectstorage_bucket" "dr_bucket" {
  provider       = oci.destination
  compartment_id = var.compartment_id
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  name           = var.display_name
  access_type    = "NoPublicAccess"
}

data "oci_objectstorage_bucket_summaries" "dr_buckets" {
  provider       = oci.destination
  compartment_id = var.compartment_id
  namespace      = data.oci_objectstorage_namespace.ns.namespace

  filter {
    name   = "name"
    values = [oci_objectstorage_bucket.dr_bucket.name]
  }
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 120"
  }
}

resource "oci_objectstorage_replication_policy" "dr_replication_policy" {
  count      = var.add_replication_policy ? 1 : 0
  provider   = oci.destination
  depends_on = [null_resource.delay]

  #Required
  bucket                              = oci_objectstorage_bucket.dr_bucket.name
  destination_bucket_name             = var.destination_bucket_name
  destination_region_name             = var.destination_region_name
  name                                = var.replication_policy_name
  delete_object_in_destination_bucket = var.delete_object_in_destination_bucket
  namespace                           = data.oci_objectstorage_namespace.ns.namespace
}

