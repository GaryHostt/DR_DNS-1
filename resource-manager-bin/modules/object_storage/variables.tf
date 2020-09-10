variable display_name {
  type        = string
  description = "name of the bucket"
}

variable freeform_tags {
  type        = map
  description = "map of freeform tags to apply to all resources created by this module"
  default     = {}
}

variable defined_tags {
  type        = map
  description = "map of defined tags to apply to all resources created by this module"
  default     = {}
}

variable compartment_id {
  type        = string
  description = "ocid of the compartment to provision the resources in"
}

variable add_replication_policy {
  description = "If true, add bucket replication policy"
  type        = bool
  default     = false
}

variable destination_bucket_name {
  type        = string
  description = "The bucket to replicate to in the destination region."
  default     = null
}

variable destination_region_name {
  type        = string
  description = "The destination region to replicate2, for exampleus-ashburn-1."
  default     = null
}

variable delete_object_in_destination_bucket {
  type        = string
  description = "The flag that indicates user understand they will delete the objects in destination bucket"
  default     = "ACCEPT"
}

variable replication_policy_name {
  type        = string
  description = "The name of the policy."
  default     = "ash_2_phx_replication"
}

