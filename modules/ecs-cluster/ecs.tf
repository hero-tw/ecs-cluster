resource "aws_ecs_cluster" "cluster" {
  name = "${var.cluster_name}-${var.environment}"
}
