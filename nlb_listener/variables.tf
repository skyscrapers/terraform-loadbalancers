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

variable "target_health_threshold" {
  description = "Int(optional, 5): The number of consecutive health checks successes before considering a target healthy"
  default     = 5
}

variable "target_type" {
  description = "The type of target that you must specify when registering targets with this target group. The possible values are instance (targets are specified by instance ID) or ip (targets are specified by IP address). The default is instance"
  default     = "instance"
}

variable "tags" {
  description = "Map(optional, {}): Optional tags"
  type        = "map"
  default     = {}
}
