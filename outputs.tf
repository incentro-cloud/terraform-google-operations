output "project_buckets" {
  value       = module.project_buckets.project_buckets
  description = "The project log buckets."
}

output "project_buckets_names" {
  value       = [for project_bucket in module.project_buckets.project_buckets : project_bucket.name]
  description = "The names of the project log buckets."
}

output "project_sinks" {
  value       = module.project_sinks.project_sinks
  description = "The log sinks."
}

output "project_sinks_names" {
  value       = [for project_sink in module.project_sinks.project_sinks : project_sink.name]
  description = "The names of the log sinks."
}

output "project_sinks_unique_writer_identities" {
  value       = [for project_sink in module.project_sinks.project_sinks : project_sink.writer_identity]
  description = "The writer identities of the log sinks."
}

output "project_sinks_names_unique_writer_identities" {
  value = {
    names                    = [for project_sink in module.project_sinks.project_sinks : project_sink.name]
    unique_writer_identities = [for project_sink in module.project_sinks.project_sinks : project_sink.writer_identity]
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

output "metric_descriptors" {
  value       = module.metric_descriptors.metric_descriptors
  description = "The metric descriptors."
}
