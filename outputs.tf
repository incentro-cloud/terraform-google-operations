output "buckets" {
  value       = module.buckets.buckets
  description = "The log buckets."
}

output "buckets_names" {
  value       = [for x in module.buckets.buckets : x.name]
  description = "The names of the log buckets."
}

output "sinks" {
  value       = module.sinks.sinks
  description = "The log sinks."
}

output "sinks_names" {
  value       = [for x in module.sinks.sinks : x.name]
  description = "The names of the log sinks."
}

output "sinks_unique_writer_identities" {
  value = [for x in module.sinks.sinks : x.writer_identity]
  description = "The writer identities of the log sinks."
}

output "sinks_names_unique_writer_identities" {
  value = {
    names            = [for x in module.sinks.sinks : x.name]
    unique_writer_identities = [for x in module.sinks.sinks : x.writer_identity]
  }

  description = "The names and writer identities of the log sinks."
}
