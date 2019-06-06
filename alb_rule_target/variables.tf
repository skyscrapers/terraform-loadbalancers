variable "name" {
  description = "String(required): Name for the target group"
}

variable "environment" {
  description = "String(required): Environment where this target group is deployed, eg. staging"
}

variable "project" {
  description = "String(required): The current project"
}

variable "vpc_id" {
  description = "String(required): The ID of the VPC in which to deploy the target group"
}

variable "listener_arn" {
  description = "String(required): The ARN of the listener to which to attach the rule"
}

variable "listener_priority" {
  description = "Int(required): The priority for the rule"
}

variable "listener_condition_field" {
  description = "String(optional, \"path-pattern\"): Must be one of `path-pattern` for path based routing or `host-header` for host based routing"
  default     = "path-pattern"
}

variable "listener_condition_values" {
  description = "List(required): The path or host patterns to match. A maximum of 1 can be defined"
  type        = list(string)
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
  type        = list(string)
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

variable "target_health_protocol" {
  description = "String(optional): The protocol to use for the health check. If not set, it will use the same protocal as target_protocol"
  default     = ""
}

variable "tags" {
  description = "Map(optional, {}): Optional tags"
  type        = map(string)
  default     = {}
}

variable "target_type" {
  description = "The type of target that you must specify when registering targets with this target group. The possible values are instance (targets are specified by instance ID) or ip (targets are specified by IP address). The default is instance"
  default     = "instance"
}

