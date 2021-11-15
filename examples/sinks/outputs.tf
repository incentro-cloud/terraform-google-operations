output "operations_buckets" {
  value       = module.operations.buckets
  description = "The log buckets."
}

output "operations_sinks" {
  value       = module.operations.sinks
  description = "The log sinks."
}
