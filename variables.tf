variable "account_id" {}
variable "domain" {}
variable "environment" {}
variable "cluster_name" {}
variable "profile" {}
variable "aws_region" {}
variable "vpc_cidr" {}

variable "public_cidr_blocks" {
  type = "list"
}

variable "private_cidr_blocks" {
  type = "list"
}

variable "vpc_name" {}
variable "autoscaling_initial_count" {}
variable "autoscaling_min_capacity" {}
variable "autoscaling_max_capacity" {}
