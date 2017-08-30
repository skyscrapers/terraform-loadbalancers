resource "aws_security_group" "sg_alb" {
  name        = "sg_alb_${var.project}_${var.environment}_${var.name}"
  description = "Security group that is needed for the alb"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "${var.project}-${var.environment}-${var.name}-sg_alb"
    Environment = "${var.environment}"
    Project     = "${var.project}"
  }
}

resource "aws_security_group_rule" "sg_alb_https_ingress" {
  type              = "ingress"
  from_port         = "${var.https_port}"
  to_port           = "${var.https_port}"
  protocol          = "tcp"
  cidr_blocks       = "${var.source_subnets}"
  security_group_id = "${aws_security_group.sg_alb.id}"
}

resource "aws_security_group_rule" "sg_alb_backend_egress" {
  count                    = "${length(var.backend_sg) == 0 ? 0 : 1}"
  type                     = "egress"
  from_port                = "${var.backend_https_port}"
  to_port                  = "${var.backend_https_port}"
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.sg_alb.id}"
  source_security_group_id = "${var.backend_sg[count.index]}"
}
