variable "name_prefix" {
  description = "String(required): Name prefix of the ALB and security group"
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
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "Bool(optional, false): Whether to enable deletion protection of this ALB or not"
  default     = false
}

variable "access_logs" {
  description = "List(optional, []): An ALB access_logs block"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Map(optional, {}): Optional tags"
  type        = map(string)
  default     = {}
}

