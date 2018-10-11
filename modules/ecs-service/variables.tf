# container defaults

variable "taskdef_cpu" {
  default = "4096"
}

variable "taskdef_memory" {
  default = "16384"
}

variable "autoscaling_initial_count" {
  default = "1"
}

variable "autoscaling_min_capacity" {
  default = "1"
}

variable "autoscaling_max_capacity" {
  default = "2"
}

variable "autoscaling_cooldown_seconds" {
  default = "60"
}

variable "autoscaling_scale_down_threshold" {
  default = "5"
}

variable "autoscaling_scale_up_threshold" {
  default = "80"
}

variable "idle_timeout" {
  default = "30"
}

variable "cluster_name" {}
variable "account_id" {}
variable "aws_region" {}
variable "environment" {}
variable "domain" {}
variable "vpc_id" {}

variable "internal_security_group" {
  type = "list"
}

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

variable "container_def" {}
variable "service_name" {}
variable "port" {}
variable "cluster_role_arn" {}

variable "health_check" {
  type = "map"
}

variable "internal_lb" {
  default = true
}
