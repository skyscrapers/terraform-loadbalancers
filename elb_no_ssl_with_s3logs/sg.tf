resource "aws_security_group" "elb" {
  name        = "${var.project}-${var.environment}-${var.name}-sg_elb"
  description = "Allow all inbound traffic"
  vpc_id      = data.aws_subnet.subnet_info.vpc_id
}

resource "aws_security_group_rule" "allow_elb_incoming_from_world" {
  security_group_id = aws_security_group.elb.id
  type              = "ingress"
  from_port         = var.lb_port
  to_port           = var.lb_port
  protocol          = "tcp"
  cidr_blocks       = var.ingoing_allowed_ips
}

resource "aws_security_group_rule" "allow_elb_outgoing_to_backend" {
  count                    = var.backend_security_groups_count
  security_group_id        = aws_security_group.elb.id
  type                     = "egress"
  from_port                = var.instance_port
  to_port                  = var.instance_port
  protocol                 = "tcp"
  source_security_group_id = var.backend_security_groups[count.index]
}

data "aws_subnet" "subnet_info" {
  id = var.subnets[0]
}

