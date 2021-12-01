# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# PROJECT LOG BUCKETS
# Submodule for creating the project log buckets.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ---------------------------------------------------------------------------------------------------------------------
# TERRAFORM CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.0.0"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# PROJECT LOG BUCKETS
# ---------------------------------------------------------------------------------------------------------------------

resource "google_logging_project_bucket_config" "project_buckets" {
  for_each       = { for project_bucket in var.project_buckets : project_bucket.bucket_id => project_bucket }
  bucket_id      = each.value.bucket_id
  project        = var.project_id
  description    = each.value.description
  location       = each.value.location
  retention_days = each.value.retention_days
}
