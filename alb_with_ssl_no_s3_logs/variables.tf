variable "vpc_id" {
  description = "ID of the VPC where to deploy in"
}

variable "backend_security_group" {
  description = "The security group of the ALB backend instances"
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

variable "http_port" {
  description = "HTTPS port the ALB is listening to"
  default     = 80
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

variable "backend_http_port" {
  default = "80"
}

variable "backend_https_port" {
  default = "8443"
}

variable "backend_http_protocol" {
  default = "HTTP"
}

variable "backend_https_protocol" {
  default = "HTTP"
}

variable "source_subnets" {
  type        = "list"
  description = "Subnets cidr blocks from where the ALB will receive the traffic"
  default  = ["0.0.0.0/0"]
}
