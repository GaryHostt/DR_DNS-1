output dr_namespace {
  value = "${data.oci_objectstorage_namespace.ns.namespace}"
}

output dr_bucket_summaries {
  value = "${data.oci_objectstorage_bucket_summaries.dr_buckets.bucket_summaries}"
}

output dr_bucket_name {
  value = "${oci_objectstorage_bucket.dr_bucket.name}"
}