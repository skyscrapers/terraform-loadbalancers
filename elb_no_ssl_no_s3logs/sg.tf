resource "aws_security_group" "elb" {
  name        = "${var.project}-${var.environment}-${var.name}-sg_elb"
  description = "Allow all inbound traffic"
  vpc_id      = "${data.aws_subnet.subnet_info.vpc_id}"

  ingress {
    from_port   = "${var.lb_port}"
    to_port     = "${var.lb_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = "${var.instance_port}"
    to_port         = "${var.instance_port}"
    protocol        = "tcp"
    security_groups = ["${var.backend_sg}"]
  }
}

data "aws_subnet" "subnet_info" {
  id = "${var.subnets[0]}"
}
