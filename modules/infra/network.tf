data "aws_availability_zones" "available" {}

resource "aws_internet_gateway" "ig" {
  vpc_id = "${var.vpc_id}"

  tags {
    Terraform = "true"
  }
}

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = ["aws_internet_gateway.ig"]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${element(aws_subnet.public_subnet.*.id, 0)}"
  depends_on    = ["aws_internet_gateway.ig"]

  tags {
    Terraform = "true"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${var.vpc_id}"
  count                   = "${length(var.public_cidr_blocks)}"
  cidr_block              = "${element(var.public_cidr_blocks, count.index)}"
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Terraform = "true"
    Name      = "public"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = "${var.vpc_id}"
  count                   = "${length(var.private_cidr_blocks)}"
  cidr_block              = "${element(var.private_cidr_blocks, count.index)}"
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"
  map_public_ip_on_launch = false

  tags {
    Terraform = "true"
    Name      = "private"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name      = "private"
    Terraform = "true"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name      = "private"
    Terraform = "true"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.ig.id}"
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat.id}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_cidr_blocks)}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.private_cidr_blocks)}"
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}
