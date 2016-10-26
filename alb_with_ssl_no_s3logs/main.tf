resource "aws_security_group" "sg_alb" {
  name        = "sg_alb_${var.project}_${var.environment}_${var.name}"
  description = "Security group that is needed for the elb"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "${var.project}-${var.environment}-${var.name}-sg_alb"
    Environment = "${var.environment}"
    Project     = "${var.project}"
  }
}

resource "aws_security_group_rule" "sg_alb_http_ingress" {
  type              = "ingress"
  from_port         = "${var.lb_port}"
  to_port           = "${var.lb_port}"
  protocol          = "tcp"
  cidr_blocks       = ["${var.source_subnets}"]
  security_group_id = "${aws_security_group.sg_alb.id}"
}

resource "aws_security_group_rule" "sg_alb_https_ingress" {
  type              = "ingress"
  from_port         = "${var.lb_ssl_port}"
  to_port           = "${var.lb_ssl_port}"
  protocol          = "tcp"
  cidr_blocks       = ["${var.source_subnets}"]
  security_group_id = "${aws_security_group.sg_alb.id}"
}

resource "aws_security_group_rule" "sg_alb_backend_egress" {
  type                     = "egress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.sg_alb.id}"
  source_security_group_id = "${var.backend_security_group}"
}

# Create a new load balancer
resource "aws_alb" "alb" {
  name            = "${var.project}-${var.environment}-${var.name}-alb"
  subnets         = ["${var.subnets}"]
  internal        = "${var.internal}"
  security_groups = ["${aws_security_group.sg_alb.id}"]

  tags {
    Name        = "${var.project}-${var.environment}-${var.name}-alb"
    Environment = "${var.environment}"
    Project     = "${var.project}"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "${var.lb_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${var.default_target_group}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "${var.lb_ssl_port}"
  protocol          = "HTTPS"

  default_action {
    target_group_arn = "${var.default_target_group}"
    type             = "forward"
  }
}
