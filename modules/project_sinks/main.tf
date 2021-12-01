# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# PROJECT LOG SINKS
# Submodule for creating the project log sinks.
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
# PROJECT LOG SINKS
# ---------------------------------------------------------------------------------------------------------------------

resource "google_logging_project_sink" "project_sinks" {
  for_each               = { for project_sink in var.project_sinks : lower(project_sink.name) => project_sink }
  name                   = each.value.name
  project                = var.project_id
  destination            = each.value.destination
  filter                 = each.value.filter
  unique_writer_identity = each.value.unique_writer_identity
}
