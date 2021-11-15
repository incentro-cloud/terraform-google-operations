# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# OPERATIONS
# Module for creating the log buckets, log sinks, services, SLOs, and alerts.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ---------------------------------------------------------------------------------------------------------------------
# LOG BUCKETS
# ---------------------------------------------------------------------------------------------------------------------

locals {
  buckets = [
    for x in var.buckets : {
      bucket_id      = x.bucket_id
      project        = var.project_id
      description    = lookup(x, "description", null)
      location       = lookup(x, "location", "global")
      retention_days = lookup(x, "retention_days", 90)
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
    for x in var.sinks : {
      name                   = x.name
      destination            = x.destination
      filter                 = lookup(x, "filter", null)
      unique_writer_identity = lookup(x, "unique_writer_identity", true)
    }
  ]
}

module "sinks" {
  source = "./modules/sinks"

  project_id = var.project_id
  sinks      = local.sinks
}
