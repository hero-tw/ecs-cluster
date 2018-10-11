data "aws_iam_policy_document" "role_doc" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com", "ec2.amazonaws.com", "ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "role_policy_doc" {
  statement {
    actions = ["kms:Decrypt"]
    effect  = "Allow"

    resources = [
      "arn:aws:kms:${var.aws_region}:${var.account_id}:key/*",
    ]
  }
}

resource "aws_iam_role" "role" {
  name               = "${var.cluster_name}-${var.environment}"
  assume_role_policy = "${data.aws_iam_policy_document.role_doc.json}"
}

resource "aws_iam_role_policy" "iam_role_policy" {
  name   = "${var.cluster_name}-${var.environment}"
  role   = "${aws_iam_role.role.id}"
  policy = "${data.aws_iam_policy_document.role_policy_doc.json}"
}

data "aws_iam_policy_document" "ecs-policy" {
  statement {
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
      "cloudwatch:PutMetricData",
      "ssm:GetParameter",
    ]

    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["ecs:*", "ecr:*", "logs:*", "iam:PassRole", "iam:GetRole"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs-policy" {
  name   = "${var.cluster_name}-ecs-policy-${var.environment}"
  policy = "${data.aws_iam_policy_document.ecs-policy.json}"
}

resource "aws_iam_policy_attachment" "ecs-policy" {
  name       = "${var.cluster_name}-ecs-policy-attach-${var.environment}"
  roles      = ["${aws_iam_role.role.name}"]
  policy_arn = "${aws_iam_policy.ecs-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
