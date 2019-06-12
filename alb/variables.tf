variable "name_prefix" {
  description = "String(optional): Name prefix of the ALB and security group"
  default     = null
}

variable "name" {
  description = "String(optional): Name prefix of the ALB and security group in the format var.project-var.environment-var.name"
  default     = null
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
  description = "An ALB access_logs block"
  type        = map(string)
  default     = null
}

variable "tags" {
  description = "Map(optional, {}): Optional tags"
  type        = map(string)
  default     = {}
}
