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

resource "google_monitoring_metric_descriptor" "descriptors" {
  for_each     = { for descriptor in var.descriptors : lower(descriptor.display_name) => descriptor }
  display_name = each.value.display_name
  project      = var.project_id
  description  = each.value.description
  type         = each.value.type
  metric_kind  = each.value.metric_kind
  value_type   = each.value.value_type
  unit         = each.value.unit
  launch_stage = each.value.launch_stage

  dynamic "labels" {
    for_each = lookup(each.value, "labels") == null ? [] : [each.value.labels]
    content {
      key         = labels.value.key
      value_type  = lookup(labels.value, "value_type", null)
      description = lookup(labels.value, "description", null)
    }
  }

  dynamic "metadata" {
    for_each = lookup(each.value, "metadata") == null ? [] : [each.value.metadata]
    content {
      sample_period = lookup(metadata.value, "sample_period", null)
      ingest_delay  = lookup(metadata.value, "ingest_delay", null)
    }
  }
}