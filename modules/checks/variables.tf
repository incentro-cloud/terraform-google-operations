variable "project_id" {
  type        = string
  description = "The project identifier."
}

variable "checks" {
  type        = any
  description = "The uptime checks."
}
