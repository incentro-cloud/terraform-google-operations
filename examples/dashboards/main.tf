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
# DASHBOARDS
# ---------------------------------------------------------------------------------------------------------------------

module "operations" {
  source = "../../"

  project_id = var.project_id

  dashboards = [
    {
      dashboard_json = file("./assets/dashboard.json")
    }
  ]
}
