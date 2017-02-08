
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
  name     = "${var.project}-${var.environment}-${var.name}-http"
  port     = "${var.backend_http_port}"
  protocol = "${var.backend_http_protocol}"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_alb_target_group" "https_target_group" {
  name     = "${var.project}-${var.environment}-${var.name}-https"
  port     = "${var.backend_https_port}"
  protocol = "${var.backend_https_protocol}"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "${var.https_port}"
  protocol          = "HTTPS"
  certificate_arn   = "${var.ssl_certificate_id}"

  default_action {
    target_group_arn = "${aws_alb_target_group.https_target_group.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "${var.http_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.http_target_group.arn}"
    type             = "forward"
  }
}
