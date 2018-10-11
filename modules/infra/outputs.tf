output "internal_access_security_group" {
  value = "${aws_security_group.internal_security_group.id}"
}

output "public_access_security_group" {
  value = "${aws_security_group.public_security_group.id}"
}

output "private_subnets" {
  value = "${aws_subnet.private_subnet.*.id}"
}

output "public_subnets" {
  value = "${aws_subnet.public_subnet.*.id}"
}

output "list_security_group" {
  value = ["${aws_security_group.internal_security_group.id}"]
}
