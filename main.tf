# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# OPERATIONS
# Module for creating the log buckets, log sinks, services, SLOs, and alerts.
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
