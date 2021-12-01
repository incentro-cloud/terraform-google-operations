output "buckets" {
  value       = module.buckets.buckets
  description = "The log buckets."
}

output "buckets_names" {
  value       = [for x in module.buckets.buckets : x.name]
  description = "The names of the log buckets."
}

output "project_sinks" {
  value       = module.project_sinks.project_sinks
  description = "The log sinks."
}

output "project_sinks_names" {
  value       = [for x in module.project_sinks.project_sinks : x.name]
  description = "The names of the log sinks."
}

output "project_sinks_unique_writer_identities" {
  value       = [for x in module.project_sinks.project_sinks : x.writer_identity]
  description = "The writer identities of the log sinks."
}

output "project_sinks_names_unique_writer_identities" {
  value = {
    names                    = [for x in module.project_sinks.project_sinks : x.name]
    unique_writer_identities = [for x in module.project_sinks.project_sinks : x.writer_identity]
  }
  description = "The names and writer identities of the log sinks."
}

output "services" {
  value       = module.services.services
  description = "The custom services."
}

output "dashboards_ids" {
  value       = [for dashboard in module.dashboards.dashboards : dashboard.id]
  description = "The identifiers of the dashboards."
}

output "slos" {
  value       = module.slos.slos
  description = "The SLOs."
}

output "policies" {
  value       = module.policies.policies
  description = "The alert policies."
}
