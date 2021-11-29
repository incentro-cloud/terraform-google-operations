# Operations module

![Cloud Build status](https://badger-tcppdqobjq-ew.a.run.app/build/status?project=examples-331911&id=55a9baae-ec58-4762-afce-b2274da03f5f "Cloud Build status")

Module for creating the log buckets, log sinks, services, SLOs, and alerts.

This module supports creating:

- Log buckets
- Log sinks
- Custom services (In progress)
- SLOs (In progress)
- Alerts (In progress)

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

  sinks = [
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
}
```
