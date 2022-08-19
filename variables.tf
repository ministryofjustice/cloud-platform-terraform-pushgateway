variable "namespace" {
  default     = ""
  description = "Namespace name"
  type        = string
}

variable "enable_service_monitor" {
  default     = true
  type        = bool
  description = "Whether to enable service monitor"
}
