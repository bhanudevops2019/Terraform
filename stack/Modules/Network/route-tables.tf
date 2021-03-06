resource "aws_route_table" "public-rt" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  route {
    cidr_block = "${var.MANAGEMENT_CIDR}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peer.id}"
  }

  tags = {
    Name            = "${var.PROJECT_NAME}-${var.ENV}-Public-RT"
    Project-ENV     = "${var.ENV}"
    Project-NAME    = "${var.PROJECT_NAME}"
    Created-By      = "Terraform"
  }
}

resource "aws_route_table" "private-rt" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "${var.MANAGEMENT_CIDR}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peer.id}"
  }

  tags = {
    Name            = "${var.PROJECT_NAME}-${var.ENV}-Private-RT"
    Project-ENV     = "${var.ENV}"
    Project-NAME    = "${var.PROJECT_NAME}"
    Created-By      = "Terraform"
  }
}

resource "aws_route_table_association" "public-rt-assoc" {
    count           = "${length(var.PUBLIC_SUBNET_CIDR)}"
    subnet_id       = "${element(aws_subnet.public-subnets.*.id, count.index)}"
    route_table_id  = "${aws_route_table.public-rt.id}"
}

resource "aws_route_table_association" "private-rt-assoc" {
    count           = "${length(var.PRIVATE_SUBNET_CIDR)}"
    subnet_id       = "${element(aws_subnet.private-subnets.*.id, count.index)}"
    route_table_id  = "${aws_route_table.private-rt.id}"
}

### Adding route of new vpc peer to exiting vpc.
resource "aws_route" "r" {
  route_table_id            = "rtb-8ecb24f6"
  destination_cidr_block    = "${var.VPC_CIDR}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peer.id}"
}
