variable "project_id" {
  type        = string
  description = "The project identifier."
}

variable "sinks" {
  type        = any
  description = "The log sinks."
  default     = []
}
