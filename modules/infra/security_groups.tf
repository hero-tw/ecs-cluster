resource "aws_security_group" "internal_security_group" {
  name_prefix = "${var.environment}-internal"
  vpc_id      = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "public_security_group" {
  name_prefix = "${var.environment}-public"
  vpc_id      = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.internal_security_group.id}"
}

resource "aws_security_group_rule" "allow_all_inbound_VPC" {
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["${var.public_cidr_blocks}", "${var.private_cidr_blocks}"]

  security_group_id = "${aws_security_group.internal_security_group.id}"
}

//
//resource "aws_security_group_rule" "SSH_From_TW" {
//  type              = "ingress"
//  from_port         = "22"
//  to_port           = "22"
//  protocol          = "tcp"
//  cidr_blocks       = ["207.87.175.130/32", "4.15.214.210/32", "24.98.219.230/32"]
//  description       = "SSH from TW"
//  security_group_id = "${aws_security_group.internal_security_group.id}"
//}

