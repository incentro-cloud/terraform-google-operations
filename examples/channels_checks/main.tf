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
# NOTIFICATION CHANNELS
# ---------------------------------------------------------------------------------------------------------------------

module "operations" {
  source = "../../"

  project_id = var.project_id

  channels = [
    {
      display_name = "Notification Channel"
      type         = "email"
      labels = {
        email_address = "fake_email@blahblah.com"
      }
    }
  ]

  checks = [
    {
      display_name = "https-uptime-check"
      timeout      = "60s"

      http_check = {
        path         = "/nl-nl"
        port         = "443"
        use_ssl      = true
        validate_ssl = true
      }

      monitored_resource = {
        type = "uptime_url"
        labels = {
          host       = "www.incentro.com"
        }
      }
    }
  ]
}
