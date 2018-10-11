data aws_ecs_cluster "cluster" {
  cluster_name = "${var.cluster_name}"
}

locals {
  autoscale_resource_id = "service/${var.cluster_name}/${var.service_name}-${var.environment}"
}

resource "aws_ecs_task_definition" "taskdef" {
  lifecycle {
    ignore_changes = "*"
  }

  family             = "${var.service_name}-${var.environment}"
  cpu                = "${var.taskdef_cpu}"
  memory             = "${var.taskdef_memory}"
  execution_role_arn = "${var.cluster_role_arn}"
  task_role_arn      = "${var.cluster_role_arn}"

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  container_definitions    = "${var.container_def}"
}

module "service_dns" {
  source = "../route-53-dns"

  app_name = "${var.service_name}"
  dns_name = "${aws_lb.app.dns_name}"
  zone_id  = "${aws_lb.app.zone_id}"
  domain   = "${var.domain}"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_ecs_service" "service" {
  depends_on = ["aws_ecs_task_definition.taskdef", "aws_alb_listener.tcp"]

  lifecycle {
    ignore_changes = "*"
  }

  name    = "${var.service_name}-${var.environment}"
  cluster = "${data.aws_ecs_cluster.cluster.cluster_name}"

  desired_count = "${var.autoscaling_initial_count}"

  deployment_maximum_percent         = "200"
  deployment_minimum_healthy_percent = "100"
  launch_type                        = "FARGATE"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.tcp.arn}"
    container_name   = "${var.service_name}"
    container_port   = "${var.port}"
  }

  network_configuration {
    subnets          = ["${var.public_subnets}"]
    security_groups  = ["${var.internal_security_group}"]
    assign_public_ip = true
  }

  task_definition = "${aws_ecs_task_definition.taskdef.family}:${max("${aws_ecs_task_definition.taskdef.revision}", "${data.aws_ecs_task_definition.taskdef.revision}")}"
}

data "aws_ecs_task_definition" "taskdef" {
  depends_on      = ["aws_ecs_task_definition.taskdef"]
  task_definition = "${aws_ecs_task_definition.taskdef.family}"
}

resource "aws_ecr_repository" "ecr_repo" {
  name = "${var.service_name}-${var.environment}"
}
