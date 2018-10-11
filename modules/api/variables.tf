variable "service_name" {}
variable "account_id" {}
variable "aws_region" {}
variable "environment" {}
variable "cluster_name" {}
variable "domain" {}
variable "vpc_id" {}
variable "internal_security_group" {}
variable "public_security_group" {}

variable "tags" {
  type = "map"
}

variable "private_subnets" {
  type = "list"
}

variable "public_subnets" {
  type = "list"
}

variable "role_arn" {}
variable "autoscaling_initial_count" {}

variable "autoscaling_min_capacity" {}

variable "autoscaling_max_capacity" {}
