variable "project_id" {
  type        = string
  description = "Required. The project identifier."
}

variable "project_buckets" {
  type        = any
  description = "Required. The project log buckets."
}
