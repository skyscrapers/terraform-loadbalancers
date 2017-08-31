variable "project" {}

variable "environment" {}

variable "name" {}

variable "backend_security_groups" {
  description = "The security groups of the ELB backends instances"
  type        = "list"
}

variable "subnets" {
  description = "A list of subnet IDs to attach to the ELB."
  type        = "list"
}

variable "internal" {
  description = "If true, ELB will be an internal ELB."
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle."
  default     = "60"
}

variable "connection_draining" {
  description = "Boolean to enable connection draining."
  default     = true
}

variable "connection_draining_timeout" {
  description = "The time in seconds to allow for connections to drain."
  default     = "60"
}

variable "access_logs_bucket" {
  description = "The S3 bucket name to store the logs in."
}

variable "access_logs_bucket_prefix" {
  description = "The S3 bucket prefix. Logs are stored in the root if not configured."
  default     = ""
}

variable "access_logs_interval" {
  description = "The publishing interval in minutes."
  default     = "60"
}

variable "access_logs_enabled" {
  default = true
}

variable "instance_port" {
  description = "The port on the instance to route to"
  default     = 80
}

variable "instance_protocol" {
  description = "The protocol to use to the instance. Valid values are HTTP, HTTPS, TCP, or SSL"
  default     = "http"
}

variable "lb_port" {
  description = "The port to listen on for the load balancer"
  default     = 80
}

variable "lb_protocol" {
  description = "The protocol to listen on. Valid values are HTTP, HTTPS, TCP, or SSL"
  default     = "http"
}

variable "healthy_threshold" {
  description = "The number of checks before the instance is declared healthy."
  default     = 3
}

variable "unhealthy_threshold" {
  description = "The number of checks before the instance is declared unhealthy."
  default     = 2
}

variable "health_timeout" {
  description = "The length of time before the check times out."
  default     = 3
}

variable "health_target" {
  description = "The target of the check. Valid pattern is ${PROTOCOL}:${PORT}${PATH}"
}

variable "health_interval" {
  description = " The interval between checks."
  default     = 30
}

variable "ingoing_allowed_ips" {
  default = ["0.0.0.0/0"]
  type    = "list"
}
