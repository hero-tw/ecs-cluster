provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "zone" {
  name   = "${var.domain}"
  vpc_id = "${module.vpc.id}"
}

module "Cluster" {
  source         = "./modules"
  vpc_id         = "${module.vpc.id}"
  route_table_id = "${module.vpc.routing_table_id}"
  account_id     = "${var.account_id}"
  environment    = "${var.environment}"
  domain         = "${aws_route53_zone.zone.name}"
  cluster_name   = "${var.cluster_name}"
  profile        = "${var.profile}"
  aws_region     = "${var.aws_region}"

  public_cidr_blocks        = "${var.public_cidr_blocks}"
  private_cidr_blocks       = "${var.private_cidr_blocks}"
  autoscaling_initial_count = "${var.autoscaling_initial_count}"
  autoscaling_max_capacity  = "${var.autoscaling_max_capacity}"
  autoscaling_min_capacity  = "${var.autoscaling_min_capacity}"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_name = "${var.vpc_name}"
  vpc_cidr = "${var.vpc_cidr}"
}
