resource "aws_cloudwatch_metric_alarm" "app_service_high_cpu" {
  alarm_name          = "${var.service_name}-${var.environment}-alarm-high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.autoscaling_scale_up_threshold}"

  dimensions {
    ClusterName = "${data.aws_ecs_cluster.cluster.cluster_name}"
    ServiceName = "${var.service_name}-${var.environment}"
  }

  ok_actions = [
    "${aws_sns_topic.service_alerts.arn}",
  ]

  alarm_actions = [
    "${aws_appautoscaling_policy.scale_up_policy.arn}",
    "${aws_sns_topic.service_alerts.arn}",
  ]
}

resource "aws_cloudwatch_metric_alarm" "app_service_low_cpu" {
  alarm_name          = "${var.service_name}-${var.environment}-alarm-low-cpu"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.autoscaling_scale_down_threshold}"

  dimensions {
    ClusterName = "${data.aws_ecs_cluster.cluster.cluster_name}"
    ServiceName = "${var.service_name}-${var.environment}"
  }

  ok_actions = [
    "${aws_sns_topic.service_alerts.arn}",
  ]

  alarm_actions = [
    "${aws_appautoscaling_policy.scale_down_policy.arn}",
    "${aws_sns_topic.service_alerts.arn}",
  ]
}

resource "aws_appautoscaling_target" "autoscale_target" {
  depends_on = ["aws_ecs_service.service"]

  min_capacity = "${var.autoscaling_min_capacity}"
  max_capacity = "${var.autoscaling_max_capacity}"
  resource_id  = "${local.autoscale_resource_id}"
  role_arn     = "arn:aws:iam::${var.account_id}:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService"

  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_down_policy" {
  name               = "${var.service_name}-${var.environment}-scale-down-policy"
  resource_id        = "${local.autoscale_resource_id}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    metric_aggregation_type = "Maximum"
    cooldown                = "${var.autoscaling_cooldown_seconds}"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = ["aws_appautoscaling_target.autoscale_target"]
}

resource "aws_appautoscaling_policy" "scale_up_policy" {
  name               = "${var.service_name}--${var.environment}-scale-up-policy"
  resource_id        = "${local.autoscale_resource_id}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    metric_aggregation_type = "Maximum"
    cooldown                = "${var.autoscaling_cooldown_seconds}"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = ["aws_appautoscaling_target.autoscale_target", "aws_ecs_service.service"]
}

resource "aws_cloudwatch_metric_alarm" "elb_health_check" {
  alarm_name          = "${var.service_name}-${var.environment}-health-check"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ELB"
  period              = "300"
  statistic           = "Average"
  threshold           = "1"

  alarm_description = "ELB instance has been unhealthy for 5 minutes"
  alarm_actions     = ["${aws_sns_topic.service_alerts.arn}"]
  ok_actions        = ["${aws_sns_topic.service_alerts.arn}"]

  dimensions {
    LoadBalancerName = "${aws_lb.app.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "elb_healthy_instances" {
  alarm_name          = "${var.service_name}--${var.environment}-healthy-instances"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ELB"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "1"

  alarm_description = "Number of healthy instances in an ELB"
  alarm_actions     = ["${aws_sns_topic.service_alerts.arn}"]
  ok_actions        = ["${aws_sns_topic.service_alerts.arn}"]

  dimensions {
    LoadBalancerName = "${aws_lb.app.name}"
  }
}

resource "aws_sns_topic" "service_alerts" {
  name = "${var.service_name}"
}
