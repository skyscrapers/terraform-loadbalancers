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

resource "aws_alb_target_group" "http_target_group" {
  name                 = "${var.project}-${var.environment}-${var.name}-http"
  port                 = "${var.backend_http_port}"
  protocol             = "${var.backend_http_protocol}"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "${var.deregistration_delay}"

  health_check {
    interval            = "${var.http_interval}"
    path                = "${var.http_path}"
    timeout             = "${var.http_timeout}"
    healthy_threshold   = "${var.http_healthy_threshold}"
    unhealthy_threshold = "${var.http_unhealthy_threshold}"
    matcher             = "${var.http_matcher}"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "${var.http_port}"
  protocol          = "HTTP"
  certificate_arn   = "${var.ssl_certificate_id}"

  default_action {
    target_group_arn = "${aws_alb_target_group.http_target_group.arn}"
    type             = "forward"
  }
}
