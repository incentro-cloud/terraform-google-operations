# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# NOTIFICATION CHANNELS
# Submodule for creating the notification channels.
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
# NOTIFICATION CHANNELS
# ---------------------------------------------------------------------------------------------------------------------

resource "google_monitoring_notification_channel" "channels" {
  for_each     = { for channel in var.channels : lower(channel.display_name) => channel }
  type         = each.value.type
  display_name = each.value.display_name
  project      = var.project_id
  description  = each.value.description
  labels       = each.value.labels
  user_labels  = each.value.user_labels

  dynamic "sensitive_labels" {
    for_each = lookup(each.value, "sensitive_labels") == null ? [] : [each.value.sensitive_labels]
    content {
      auth_token  = lookup(sensitive_labels.value, "auth_token", null)
      password    = lookup(sensitive_labels.value, "password", null)
      service_key = lookup(sensitive_labels.value, "service_key", null)
    }
  }
}