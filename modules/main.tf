module "ecs_cluster" {
  source = "./ecs-cluster"

  cluster_name = "${var.cluster_name}"
  account_id   = "${var.account_id}"
  vpc_id       = "${var.vpc_id}"
  aws_region   = "${var.aws_region}"
  environment  = "${var.environment}"
}

module "api" {
  source = "./api"

  service_name = "config-demo"

  cluster_name = "${module.ecs_cluster.cluster}"

  tags = {
    Name   = "config-demo"
    Domain = "${var.domain}"
  }

  aws_region                = "${var.aws_region}"
  domain                    = "${var.domain}"
  account_id                = "${var.account_id}"
  internal_security_group   = "${module.infra.internal_access_security_group}"
  private_subnets           = ["${module.infra.private_subnets}"]
  public_subnets            = ["${module.infra.public_subnets}"]
  vpc_id                    = "${var.vpc_id}"
  public_security_group     = "${module.infra.public_access_security_group}"
  role_arn                  = "${module.ecs_cluster.cluster_role_name}"
  autoscaling_initial_count = "${var.autoscaling_initial_count}"
  autoscaling_min_capacity  = "${var.autoscaling_min_capacity}"
  autoscaling_max_capacity  = "${var.autoscaling_max_capacity}"
  environment               = "${var.environment}"
}

module "infra" {
  source = "./infra"

  route_table_id = "${var.route_table_id}"
  vpc_id         = "${var.vpc_id}"
  domain         = "${var.domain}"
  environment    = "${var.environment}"

  aws_region = "${var.aws_region}"
  account_id = "${var.account_id}"

  public_cidr_blocks  = "${var.public_cidr_blocks}"
  private_cidr_blocks = "${var.private_cidr_blocks}"
}
