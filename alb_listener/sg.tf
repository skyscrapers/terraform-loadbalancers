resource "aws_security_group_rule" "sg_alb_ingress" {
  security_group_id = var.alb_sg_id
  type              = "ingress"
  from_port         = var.ingress_port == -1 ? var.https_certificate_arn == "" ? 80 : 443 : var.ingress_port
  to_port           = var.ingress_port == -1 ? var.https_certificate_arn == "" ? 80 : 443 : var.ingress_port
  protocol          = "tcp"
  cidr_blocks       = var.source_subnet_cidrs
}

