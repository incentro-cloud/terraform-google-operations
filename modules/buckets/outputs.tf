output "buckets" {
  value       = google_logging_project_bucket_config.buckets
  description = "The log buckets."
}
