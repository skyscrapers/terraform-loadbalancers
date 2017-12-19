variable "name_prefix" {
  description = "String(required): Name prefix of the NLB listener"
}

variable "environment" {
  description = "String(required): Environment where this NLB listener is deployed, eg. staging"
}

variable "project" {
  description = "String(required): The current project"
}

variable "vpc_id" {
  description = "String(required): The ID of the VPC in which to deploy"
}

variable "nlb_arn" {
  description = "String(required): ARN of the NLB on which this listener will be attached."
}

variable "default_target_group_arn" {
  description = "String(optional, \"\"): Default target group ARN to add to the HTTP listener. Creates a default target group if not set"
  default     = ""
}

variable "ingress_port" {
  description = "Int(required): Ingress port the NLB listener is listening to"
}

variable "nlb_sg_id" {
  description = "String(required): ID of the security group attached to the load balancer"
  default     = -1
}

variable "target_port" {
  description = "Int(optional, 80): The port of which targets receive traffic"
  default     = 80
}

variable "target_deregistration_delay" {
  description = "Int(optional, 30): The time in seconds before deregistering the target"
  default     = 30
}

variable "target_health_interval" {
  description = "Int(optional, 30): Time in seconds between target health checks"
  default     = 30
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

variable "source_subnet_cidrs" {
  description = "List(optional, [\"0.0.0.0/0\"]): Subnet CIDR blocks from where the NLB will receive traffic"
  type        = "list"
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Map(optional, {}): Optional tags"
  type        = "map"
  default     = {}
}
