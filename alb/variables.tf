variable "name" {
  description = "String(required): Name of the ALB"
}

variable "environment" {
  description = "String(required): Environment where this ALB is deployed, eg. staging"
}

variable "project" {
  description = "String(required): The current project"
}

variable "vpc_id" {
  description = "String(required): The ID of the VPC in which to deploy"
}

variable "internal" {
  description = "Bool(optional, false): Is this an internal ALB or not"
  default     = false
}

variable "subnets" {
  description = "List(required): Subnets to deploy the ALB in"
  type        = "list"
}

variable "enable_deletion_protection" {
  description = "Bool(optional, false): Whether to enable deletion protection of this ALB or not"
  default     = false
}

variable "access_logs" {
  description = "List(optional, []): An ALB access_logs block"
  type        = "list"
  default     = []
}

variable "tags" {
  description = "Map(optional, {}): Optional tags"
  type        = "map"
  default     = {}
}

variable "enable_http_listener" {
  description = "Bool(optional, false): Whether to enable the HTTP listener"
  default     = false
}

variable "http_port" {
  description = "Int(optional, 80): HTTP port the ALB is listening to"
  default     = 80
}

variable "enable_https_listener" {
  description = "Bool(optional, true): Whether to enable the HTTPS listener"
  default     = true
}

variable "https_port" {
  description = "Int(optional, 443): HTTPS port the ALB is listening to"
  default     = 443
}

variable "https_certificate_arn" {
  description = "String(required): IAM ARN of the SSL certificate for the HTTPS listener"
  default     = ""
}

variable "default_target_group_arn" {
  description = "String(optional, \"\"): Default target group ARN to add to the HTTP listener. Creates a default target group if not set"
  default     = ""
}

variable "target_port" {
  description = "Int(optional, 80): The port of which targets receive traffic"
  default     = 80
}

variable "target_protocol" {
  description = "String(optional, \"HTTP\"): The protocol to sue for routing traffic to the targets"
  default     = "HTTP"
}

variable "target_deregistration_delay" {
  description = "Int(optional, 30): The time in seconds before deregistering the target"
  default     = 30
}

variable "target_stickiness" {
  description = "List(optional, []): An ALB target_group stickiness block"
  type        = "list"
  default     = []
}

variable "target_health_interval" {
  description = "Int(optional, 30): Time in seconds between target health checks"
  default     = 30
}

variable "target_health_path" {
  description = "String(optional, \"/\"): Path for the health check request"
  default     = "/"
}

variable "target_health_timeout" {
  description = "Int(optional, 5): Time in seconds to wait for a successful health check response"
  default     = 5
}

variable "target_health_healthy_threshold" {
  description = "Int(optional, 5): The number of consecutive health checks successes before considering a target healthy"
  default     = 5
}

variable "target_health_unhealthy_threshold" {
  description = "Int(optional, 2): The number of consecutive health check failures before considering a target unhealthy"
  default     = 2
}

variable "target_health_matcher" {
  description = "Int(optional, 200): The HTTP codes to use when checking for a successful response from a target"
  default     = 200
}

variable "target_security_groups" {
  description = "List(required): Security groups of the ALB target instances"
  type        = "list"
}


variable "target_security_groups_count" {
  description = "Int(required): Number of security groups of the ALB target instances"
  default = 1
}

variable "source_subnet_cidrs" {
  description = "List(optional, [\"0.0.0.0/0\"]): Subnet CIDR blocks from where the ALB will receive traffic"
  type        = "list"
  default     = ["0.0.0.0/0"]
}

variable "target_health_protocol" {
  default     = "HTTP"
  description = "Protocol to use for the healthcheck"
}
