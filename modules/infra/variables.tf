variable "vpc_id" {}
variable "route_table_id" {}
variable "domain" {}

variable "account_id" {}
variable "aws_region" {}

variable "public_cidr_blocks" {
  type = "list"
}

variable "private_cidr_blocks" {
  type = "list"
}

variable "environment" {}
