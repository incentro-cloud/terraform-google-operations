variable "project_id" {
  type        = string
  description = "The project identifier."
}

variable "slos" {
  type        = any
  description = "The SLOs."
  default     = []
}
