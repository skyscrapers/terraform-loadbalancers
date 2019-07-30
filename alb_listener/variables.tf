variable "name_prefix" {
  description = "String(required): Name prefix of the ALB listener"
}

variable "environment" {
  description = "String(required): Environment where this ALB listener is deployed, eg. staging"
}

variable "project" {
  description = "String(required): The current project"
}

variable "vpc_id" {
  description = "String(required): The ID of the VPC in which to deploy"
}

variable "alb_arn" {
  description = "String(required): ARN of the ALB on which this listener will be attached."
}

variable "alb_sg_id" {
  description = "String(required): ID of the security group attached to the load balancer"
}

variable "default_target_group_arn" {
  description = "String(optional, \"\"): Default target group ARN to add to the HTTP listener. If this value is set please set create_default_target_group to false"
  default     = ""
}

variable "create_default_target_group" {
  description = "String(optional, true): Whether to creates or not a default target group if not set"
  default     = true
}

variable "ingress_port" {
  description = "Int(optional, HTTP/HTTPS port): Ingress port the ALB listener is listening to"
  default     = -1
}

variable "https_certificate_arn" {
  description = "String(optional, \"\"): IAM ARN of the SSL certificate for the HTTPS listener"
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
  description = "An ALB target_group stickiness block"
  type        = list(map(string))
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

variable "source_subnet_cidrs" {
  description = "List(optional, [\"0.0.0.0/0\"]): Subnet CIDR blocks from where the ALB will receive traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "target_health_protocol" {
  description = "String(optional): The protocol to use for the health check. If not set, it will use the same protocal as target_protocol"
  default     = ""
}

variable "tags" {
  description = "Map(optional, {}): Optional tags"
  type        = map(string)
  default     = {}
}

