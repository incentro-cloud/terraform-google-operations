# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# OPERATIONS
# Module for creating the log buckets, log sinks, services, SLOs, and alert policies.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ---------------------------------------------------------------------------------------------------------------------
# LOG BUCKETS
# ---------------------------------------------------------------------------------------------------------------------

locals {
  buckets = [
    for bucket in var.buckets : {
      bucket_id      = bucket.bucket_id
      project        = var.project_id
      description    = lookup(bucket, "description", null)
      location       = lookup(bucket, "location", "global")
      retention_days = lookup(bucket, "retention_days", 90)
    }
  ]
}

module "buckets" {
  source = "./modules/buckets"

  project_id = var.project_id
  buckets    = local.buckets
}

# ---------------------------------------------------------------------------------------------------------------------
# LOG SINKS
# ---------------------------------------------------------------------------------------------------------------------

locals {
  sinks = [
    for sink in var.sinks : {
      name                   = sink.name
      destination            = sink.destination
      filter                 = lookup(sink, "filter", null)
      unique_writer_identity = lookup(sink, "unique_writer_identity", true)
    }
  ]
}

module "sinks" {
  source = "./modules/sinks"

  project_id = var.project_id
  sinks      = local.sinks
}

# ---------------------------------------------------------------------------------------------------------------------
# CUSTOM SERVICES
# ---------------------------------------------------------------------------------------------------------------------

locals {
  services = [
    for service in var.services : {
      service_id    = lookup(service, "service_id", null)
      display_name  = lookup(service, "display_name", null)
      resource_name = lookup(service, "resource_name", null)
    }
  ]
}

module "services" {
  source = "./modules/services"

  project_id = var.project_id
  services   = local.services
}

# ---------------------------------------------------------------------------------------------------------------------
# DASHBOARDS
# ---------------------------------------------------------------------------------------------------------------------

locals {
  dashboards = [
    for dashboard in var.dashboards : {
      dashboard_json = dashboard.dashboard_json
    }
  ]
}

module "dashboards" {
  source = "./modules/dashboards"

  project_id = var.project_id
  dashboards = local.dashboards
}

# ---------------------------------------------------------------------------------------------------------------------
# SLOs
# ---------------------------------------------------------------------------------------------------------------------

locals {
  slos = [
    for slo in var.slos : {
      service             = slo.service
      slo_id              = lookup(slo, "slo_id", null)
      display_name        = lookup(slo, "display_name", null)
      goal                = slo.goal
      rolling_period_days = lookup(slo, "rolling_period_days", null)
      calendar_period     = lookup(slo, "calendar_period", null)
      basic_sli           = lookup(slo, "basic_sli", null)
      request_based_sli   = lookup(slo, "request_based_sli", null)
      windows_based_sli   = lookup(slo, "windows_based_sli", null)
    }
  ]
}

module "slos" {
  source = "./modules/slos"

  project_id = var.project_id
  slos       = local.slos
}

# ---------------------------------------------------------------------------------------------------------------------
# ALERT POLICIES
# ---------------------------------------------------------------------------------------------------------------------

locals {
  policies = [
    for policy in var.policies : {
      display_name          = policy.display_name
      combiner              = policy.combiner
      conditions            = policy.conditions
      enabled               = lookup(policy, "enabled", true)
      notification_channels = lookup(policy, "notification_channels", [])
      user_labels           = lookup(policy, "user_labels", null)
      documentation         = lookup(policy, "documentation", null)
    }
  ]
}

module "policies" {
  source = "./modules/policies"

  project_id = var.project_id
  policies   = local.policies
}
