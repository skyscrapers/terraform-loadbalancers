resource "aws_security_group" "elb" {
  name        = "${var.project}-${var.environment}-${var.name}-sg_elb"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = "${var.lb_ssl_port}"
    to_port     = "${var.lb_ssl_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = "${var.instance_ssl_port}"
    to_port         = "${var.instance_ssl_port}"
    protocol        = "tcp"
    security_groups = ["${var.backend_sg}"]
  }
}
