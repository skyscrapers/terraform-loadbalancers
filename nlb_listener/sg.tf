resource "aws_security_group_rule" "sg_nlb_ingress" {
  security_group_id = "${var.nlb_sg_id}"
  type              = "ingress"
  from_port         = "${var.ingress_port}"
  to_port           = "${var.ingress_port}"
  protocol          = "tcp"
  cidr_blocks       = "${var.source_subnet_cidrs}"
}
