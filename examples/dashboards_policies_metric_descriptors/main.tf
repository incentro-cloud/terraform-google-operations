# ---------------------------------------------------------------------------------------------------------------------
# TERRAFORM CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = "~> 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.0"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# DASHBOARDS, ALERT POLICIES, AND METRIC DESCRIPTORS
# ---------------------------------------------------------------------------------------------------------------------

module "operations" {
  source = "../../"

  project_id = var.project_id

  dashboards = [
    {
      dashboard_json = file("./assets/dashboard.json")
    }
  ]

  policies = [
    {
      display_name = "Alert policy"
      combiner     = "OR"

      documentation = {
        content   = file("./assets/DOCUMENTATION.md")
        mime_type = "text/markdown"
      }

      conditions = {
        display_name = "test condition"
        condition_threshold = {
          filter     = "metric.type=\"compute.googleapis.com/instance/disk/write_bytes_count\" AND resource.type=\"gce_instance\""
          duration   = "60s"
          comparison = "COMPARISON_GT"
          aggregations = {
            alignment_period   = "60s"
            per_series_aligner = "ALIGN_RATE"
          }
        }
      }

      user_labels = {
        environment = "examples"
      }
    }
  ]

  metric_descriptors = [
    {
      display_name = "Daily sales records"
      description  = "Daily sales records from all branch stores."
      type         = "custom.googleapis.com/stores/daily_sales"
      metric_kind  = "GAUGE"
      value_type   = "DOUBLE"
      unit         = "{EUR}"
    }
  ]
}
