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

variable "lb_port" {
  description = "Port the ALB is listening to"
  default     = 80
}

variable "lb_ssl_port" {
  description = "Port the ALB is listening to with SSL enabled"
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
  default     = "production"
}

variable "project" {
  description = "The current project"
}

variable "default_target_group" {
  description = "default target group for http and https listeners"
}

variable "source_subnets" {
  type        = "list"
  description = "subnets from where the ALB will receive the traffic"
}
