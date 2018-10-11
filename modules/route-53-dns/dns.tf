data "aws_route53_zone" "zone" {
  name   = "${var.domain}"
  vpc_id = "${var.vpc_id}"
}

resource "aws_route53_record" "entry" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${var.app_name}"
  type    = "A"

  alias {
    name                   = "${var.dns_name}"
    zone_id                = "${var.zone_id}"
    evaluate_target_health = false
  }
}
