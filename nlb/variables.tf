variable "name_prefix" {
  description = "String(required): Name prefix of the NLB and security group"
}

variable "environment" {
  description = "String(required): Environment where this NLB is deployed, eg. staging"
}

variable "project" {
  description = "String(required): The current project"
}

variable "vpc_id" {
  description = "String(required): The ID of the VPC in which to deploy"
}

variable "internal" {
  description = "Bool(optional, false): Is this an internal NLB or not"
  default     = false
}

variable "subnets" {
  description = "List(required): Subnets to deploy the NLB in"
  type        = "list"
}

variable "enable_deletion_protection" {
  description = "Bool(optional, false): Whether to enable deletion protection of this NLB or not"
  default     = false
}

variable "tags" {
  description = "Map(optional, {}): Optional tags"
  type        = "map"
  default     = {}
}
