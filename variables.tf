variable "project_id" {
  type        = string
  description = "The project identifier."
}

variable "buckets" {
  type        = any
  description = "The log buckets."
  default     = []
}

variable "sinks" {
  type        = any
  description = "The log sinks."
  default     = []
}

variable "services" {
  type        = any
  description = "The custom services."
  default     = []
}

variable "dashboards" {
  type        = any
  description = "The dashboards."
  default     = []
}

variable "slos" {
  type        = any
  description = "The SLOs."
  default     = []
}

variable "policies" {
  type        = any
  description = "The alert policies."
  default     = []
}

variable "groups" {
  type        = any
  description = "The monitoring groups."
  default     = []
}
