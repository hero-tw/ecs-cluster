module "ecs_service" {
  source = "../ecs-service"

  account_id                = "${var.account_id}"
  environment               = "${var.environment}"
  aws_region                = "${var.aws_region}"
  vpc_id                    = "${var.vpc_id}"
  cluster_name              = "${var.role_arn}"
  public_subnets            = "${var.public_subnets}"
  internal_security_group   = ["${var.internal_security_group}"]
  port                      = "8081"
  public_security_group     = "${var.public_security_group}"
  domain                    = "${var.domain}"
  tags                      = "${var.tags}"
  cluster_role_arn          = "${var.role_arn}"
  container_def             = "${data.template_file.def.rendered}"
  service_name              = "${var.service_name}"
  private_subnets           = "${var.private_subnets}"
  autoscaling_initial_count = "${var.autoscaling_initial_count}"
  autoscaling_min_capacity  = "${var.autoscaling_min_capacity}"
  autoscaling_max_capacity  = "${var.autoscaling_max_capacity}"

  health_check = {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = "10"
    protocol            = "HTTPS"
    interval            = 30
    path                = "/ping"
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "${var.service_name}-${var.domain}"
}

data "template_file" "def" {
  template = "${file("${path.module}/templates/containerdef.json")}"

  vars {
    def_name             = "${var.service_name}"
    def_image            = "${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.service_name}-${var.environment}:latest"
    def_region           = "${var.aws_region}"
    def_log_group        = "${aws_cloudwatch_log_group.log_group.name}"
    def_log_prefix       = "${var.service_name}-task"
    env_environment_name = "${var.environment}"
  }
}
