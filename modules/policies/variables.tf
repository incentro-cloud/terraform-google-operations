variable "project_id" {
  type        = string
  description = "The project identifier."
}

variable "policies" {
  type        = any
  description = "The alert policies."
}
