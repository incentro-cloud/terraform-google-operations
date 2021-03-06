variable "project_id" {
  type        = string
  description = "Required. The project identifier."
}

variable "project_buckets" {
  type        = any
  description = "The project log buckets."
  default     = []
}

variable "project_sinks" {
  type        = any
  description = "The project log sinks."
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

variable "descriptors" {
  type        = any
  description = "The metric descriptors."
  default     = []
}

variable "channels" {
  type        = any
  description = "The notification channels."
  default     = []
}

variable "checks" {
  type        = any
  description = "The uptime checks."
  default     = []
}
