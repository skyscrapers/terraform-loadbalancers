resource "aws_security_group" "sg_alb" {
  name        = "sg_alb_${var.project}_${var.environment}_${var.name}"
  description = "Security group for ALB ${var.project}-${var.environment}-${var.name}-alb"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge("${var.tags}",
    map("Name", "${var.project}-${var.environment}-${var.name}-sg_alb",
      "Environment", "${var.environment}",
      "Project", "${var.project}"))
  }"
}

resource "aws_security_group_rule" "sg_alb_http_ingress" {
  count             = "${var.enable_http_listener}"
  security_group_id = "${aws_security_group.sg_alb.id}"
  type              = "ingress"
  from_port         = "${var.http_port}"
  to_port           = "${var.http_port}"
  protocol          = "tcp"
  cidr_blocks       = "${var.source_subnet_cidrs}"
}

resource "aws_security_group_rule" "sg_alb_https_ingress" {
  count             = "${var.enable_https_listener}"
  security_group_id = "${aws_security_group.sg_alb.id}"
  type              = "ingress"
  from_port         = "${var.https_port}"
  to_port           = "${var.https_port}"
  protocol          = "tcp"
  cidr_blocks       = "${var.source_subnet_cidrs}"
}

resource "aws_security_group_rule" "sg_alb_target_egress" {
  count                    = "${length(var.target_security_groups)}"
  security_group_id        = "${aws_security_group.sg_alb.id}"
  type                     = "egress"
  from_port                = "${var.target_port}"
  to_port                  = "${var.target_port}"
  protocol                 = "tcp"
  source_security_group_id = "${var.target_security_groups[count.index]}"
}
