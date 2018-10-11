variable "domain" {}
variable "account_id" {}
variable "vpc_id" {}
variable "route_table_id" {}
variable "aws_region" {}
variable "profile" {}

variable "instance_type" {
  default = "t2.medium"
}

variable "public_cidr_blocks" {
  type = "list"
}

variable "private_cidr_blocks" {
  type = "list"
}

variable "autoscaling_initial_count" {
  default = "1"
}

variable "autoscaling_min_capacity" {
  default = "1"
}

variable "autoscaling_max_capacity" {
  default = "1"
}

variable "cluster_name" {}
variable "environment" {}
