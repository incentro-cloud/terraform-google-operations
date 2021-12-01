output "project_buckets" {
  value       = google_logging_project_bucket_config.project_buckets
  description = "The project log buckets."
}
