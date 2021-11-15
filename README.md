# Operations module

Module for creating the log buckets, sinks, services, SLOs, and alerts.

This module supports creating:

- Log buckets
- Log sinks
- Custom services (In progress)
- SLOs (In progress)
- Alerts (In progress)

## Usage

```hcl
module "operations" {
  source = "../../"

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
}
```