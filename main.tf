# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# OPERATIONS
# Module for creating the log buckets, log sinks, custom services, SLOs, alert policies, monitoring groups,
# and metric descriptors.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ---------------------------------------------------------------------------------------------------------------------
# PROJECT LOG BUCKETS
# ---------------------------------------------------------------------------------------------------------------------

locals {
  project_buckets = [
    for project_bucket in var.project_buckets : {
      bucket_id      = project_bucket.bucket_id
      project        = var.project_id
      description    = lookup(project_bucket, "description", null)
      location       = lookup(project_bucket, "location", "global")
      retention_days = lookup(project_bucket, "retention_days", 90)
    }
  ]
}

module "project_buckets" {
  source = "./modules/project_buckets"

  project_id      = var.project_id
  project_buckets = local.project_buckets
}

# ---------------------------------------------------------------------------------------------------------------------
# PROJECT LOG SINKS
# ---------------------------------------------------------------------------------------------------------------------

locals {
  project_sinks = [
    for project_sink in var.project_sinks : {
      name                   = project_sink.name
      destination            = project_sink.destination
      filter                 = lookup(project_sink, "filter", null)
      unique_writer_identity = lookup(project_sink, "unique_writer_identity", true)
    }
  ]
}

module "project_sinks" {
  source = "./modules/project_sinks"

  project_id    = var.project_id
  project_sinks = local.project_sinks
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

# ---------------------------------------------------------------------------------------------------------------------
# MONITORING GROUPS
# ---------------------------------------------------------------------------------------------------------------------

locals {
  groups = [
    for group in var.groups : {
      display_name = group.display_name
      filter       = group.filter
      parent_name  = lookup(group, "parent_name", null)
      is_cluster   = lookup(group, "is_cluster", false)
    }
  ]
}

module "groups" {
  source = "./modules/groups"

  project_id = var.project_id
  groups     = local.groups
}

# ---------------------------------------------------------------------------------------------------------------------
# MTERIC DESCRIPTORS
# ---------------------------------------------------------------------------------------------------------------------

locals {
  metric_descriptors = [
    for metric_descriptor in var.metric_descriptors : {
      display_name = metric_descriptor.display_name
      description  = metric_descriptor.description
      type         = metric_descriptor.type
      metric_kind  = lookup(metric_descriptor, "metric_kind", "METRIC_KIND_UNSPECIFIED")
      value_type   = metric_descriptor.value_type
      unit         = lookup(metric_descriptor, "unit", null)
      launch_stage = lookup(metric_descriptor, "launch_stage", null)
      labels       = lookup(metric_descriptor, "labels", null)
      metadata     = lookup(metric_descriptor, "metadata", null)
    }
  ]
}

module "metric_descriptors" {
  source = "./modules/metric_descriptors"

  project_id         = var.project_id
  metric_descriptors = local.metric_descriptors
}
