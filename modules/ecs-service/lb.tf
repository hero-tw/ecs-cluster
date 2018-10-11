resource "aws_lb" "app" {
  name               = "${var.service_name}-${var.environment}"
  internal           = "${var.internal_lb}"
  load_balancer_type = "network"

  enable_cross_zone_load_balancing = true

  subnets = ["${var.public_subnets}"]

  idle_timeout = "${var.idle_timeout}"
  tags         = "${var.tags}"
}

resource "aws_alb_target_group" "tcp" {
  depends_on           = ["aws_lb.app"]
  name                 = "${var.service_name}-${var.environment}"
  tags                 = "${var.tags}"
  port                 = "${var.port}"
  protocol             = "TCP"
  vpc_id               = "${var.vpc_id}"
  target_type          = "ip"
  deregistration_delay = 0

  health_check = ["${var.health_check}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener" "tcp" {
  load_balancer_arn = "${aws_lb.app.arn}"
  port              = "443"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_alb_target_group.tcp.arn}"
    type             = "forward"
  }
}
