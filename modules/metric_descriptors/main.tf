# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# METRIC DESCRIPTORS
# Submodule for creating the metric descriptors.
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
# METRIC DESCRIPTORS
# ---------------------------------------------------------------------------------------------------------------------

resource "google_monitoring_metric_descriptor" "metric_descriptors" {
  for_each     = { for metric_descriptor in var.metric_descriptors : lower(metric_descriptor.display_name) => metric_descriptor }
  display_name = each.value.display_name
  project      = var.project_id
  description  = each.value.description
  type         = each.value.type
  metric_kind  = each.value.metric_kind
  value_type   = each.value.value_type

  labels {
    key = ""
  }
}