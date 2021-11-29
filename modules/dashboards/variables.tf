variable "project_id" {
  type        = string
  description = "The project identifier."
}

variable "dashboards" {
  type        = any
  description = "The dashboards."
  default     = []
}
