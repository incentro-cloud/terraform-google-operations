# Operations module

![Cloud Build status](https://badger-tcppdqobjq-ew.a.run.app/build/status?project=examples-331911&id=55a9baae-ec58-4762-afce-b2274da03f5f "Cloud Build status")

Module for creating the project log buckets, project log sinks, custom services, SLOs, alert policies, monitoring groups, metric descriptors, notification channels, and uptime checks.

This module supports creating:

- Log buckets
- Log sinks
- Custom services
- SLOs
- Alert policies
- Monitoring groups
- Metric descriptors
- Notification channels
- Uptime checks

## Example usage

```hcl
module "operations" {
  source  = "incentro-cloud/operations/google"
  version = "~> 0.1"

  project_id = var.project_id

  buckets = [
    {
      bucket_id      = "required-logs"
      description    = "User-defined bucket for the required logs"
      location       = "global"
      retention_days = 90
    },
    {
      bucket_id      = "default-logs"
      description    = "User-defined bucket for the default logs"
      location       = "global"
      retention_days = 90
    }
  ]

  project_sinks = [
    {
      name                   = "required-logs"
      destination            = "logging.googleapis.com/projects/${var.project_id}/locations/global/buckets/required-logs"
      filter                 = "LOG_ID(\"cloudaudit.googleapis.com/activity\") OR LOG_ID(\"externalaudit.googleapis.com/activity\") OR LOG_ID(\"cloudaudit.googleapis.com/system_event\") OR LOG_ID(\"externalaudit.googleapis.com/system_event\") OR LOG_ID(\"cloudaudit.googleapis.com/access_transparency\") OR LOG_ID(\"externalaudit.googleapis.com/access_transparency\")"
      unique_writer_identity = true
    },
    {
      name                   = "default-logs"
      destination            = "logging.googleapis.com/projects/${var.project_id}/locations/global/buckets/default-logs"
      filter                 = "NOT LOG_ID(\"cloudaudit.googleapis.com/activity\") AND NOT LOG_ID(\"externalaudit.googleapis.com/activity\") AND NOT LOG_ID(\"cloudaudit.googleapis.com/system_event\") AND NOT LOG_ID(\"externalaudit.googleapis.com/system_event\") AND NOT LOG_ID(\"cloudaudit.googleapis.com/access_transparency\") AND NOT LOG_ID(\"externalaudit.googleapis.com/access_transparency\")"
      unique_writer_identity = true
    },
  ]

  services = [
    {
      service_id   = "custom-service"
      display_name = "Custom service"
    }
  ]

  dashboards = [
    {
      dashboard_json = file("./assets/dashboard.json")
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

  groups = [
    {
      display_name = "Monitoring group"
      filter       = "resource.metadata.region=\"europe-west1\""
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
```

## Inputs

Most inputs map to the supported arguments. Links to the official documentation are included.

### Project log buckets

Submodule for creating the project log buckets.

[Click here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/logging_project_bucket_config "google_logging_project_bucket_config") for the **google_logging_project_bucket_config** documentation.

| Name             | Type     | Default | Description                                                                                                         |
|------------------|----------|---------|---------------------------------------------------------------------------------------------------------------------|
| `project_id`     | string   |         | Required. The project identifier.                                                                                   |
| `bucket_id`      | string   |         | Required. The location of the project log bucket.                                                                   |
| `description`    | string   | null    | Optional. The name of the project log bucket.                                                                       |
| `location`       | string   | global  | Optional. The description of the project log bucket.                                                                |
| `retention_days` | number   | 90      | Optional. Logs will be retained by default for this amount of time, after which they will automatically be deleted. |
