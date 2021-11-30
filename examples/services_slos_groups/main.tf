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
# CUSTOM SERVICES AND SLOs
# ---------------------------------------------------------------------------------------------------------------------

module "operations" {
  source = "../../"

  project_id = var.project_id

  services = [
    {
      service_id   = "custom-service"
      display_name = "Custom service"
    }
  ]

  slos = [
    {
      service      = module.operations.services["custom-service"].service_id
      slo_id       = "consumed-api-slo"
      display_name = "SLO with request based SLI (good total ratio)"

      goal                = 0.9
      rolling_period_days = 30

      request_based_sli = {
        distribution_cut = {
          distribution_filter = "metric.type=\"serviceruntime.googleapis.com/api/request_latencies\" resource.type=\"api\""
          max                 = 0.5
        }
      }
    }
  ]

  groups = [
    {
      display_name = "Monitoring group"
      filter       = "resource.metadata.region=\"europe-west1\""
    }
  ]
}
