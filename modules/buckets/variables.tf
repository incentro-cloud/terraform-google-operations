variable "project_id" {
  type        = string
  description = "The project identifier."
}

variable "buckets" {
  type        = any
  description = "The log buckets."
  default     = []
}
