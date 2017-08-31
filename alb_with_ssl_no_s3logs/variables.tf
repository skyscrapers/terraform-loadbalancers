variable "vpc_id" {
  description = "ID of the VPC where to deploy in"
}

variable "backend_security_groups" {
  description = "The security groups of the ALB backends instances"
  type        = "list"
}

variable "subnets" {
  type        = "list"
  description = "Subnets to deploy in"
}

variable "internal" {
  description = "Is it an internal ALB or not"
  default     = false
}

variable "connection_draining_timeout" {
  description = "The time in seconds to allow for connections to drain"
  default     = "300"
}

variable "https_port" {
  description = "HTTPS port the ALB is listening to"
  default     = 443
}

variable "ssl_certificate_id" {
  description = "IAM ID of the SSL certificate if needed"
}

variable "name" {
  description = "Name of the ALB"
}

variable "environment" {
  description = "How do you want to call your environment, this is helpful if you have more than 1 VPC."
}

variable "project" {
  description = "The current project"
}

variable "backend_https_port" {
  default = "80"
}

variable "backend_https_protocol" {
  default = "HTTP"
}

variable "source_subnets" {
  type        = "list"
  description = "Subnets cidr blocks from where the ALB will receive the traffic"
  default     = ["0.0.0.0/0"]
}

variable "https_interval" {
  default = "30"
}

variable "https_path" {
  default = "/"
}

variable "https_timeout" {
  default = "5"
}

variable "https_healthy_threshold" {
  default = "5"
}

variable "https_unhealthy_threshold" {
  default = "2"
}

variable "https_matcher" {
  default = "200"
}
