output "cluster_role_arn" {
  value = "${aws_iam_role.role.arn}"
}

output "cluster_role_name" {
  value = "${aws_iam_role.role.name}"
}

output "cluster" {
  value = "${aws_ecs_cluster.cluster.id}"
}
