resource "aws_elb" "elb" {
  name                        = "${var.project}-${var.environment}-${var.name}"
  subnets                     = var.subnets
  internal                    = var.internal
  cross_zone_load_balancing   = true
  idle_timeout                = var.idle_timeout
  connection_draining         = var.connection_draining
  connection_draining_timeout = var.connection_draining_timeout
  security_groups             = [aws_security_group.elb.id]

  access_logs {
    bucket        = var.access_logs_bucket
    bucket_prefix = var.access_logs_bucket_prefix
    interval      = var.access_logs_interval
    enabled       = var.access_logs_enabled
  }

  listener {
    instance_port     = var.instance_port
    instance_protocol = var.instance_protocol
    lb_port           = var.lb_port
    lb_protocol       = var.lb_protocol
  }

  listener {
    instance_port      = var.instance_ssl_port
    instance_protocol  = var.instance_ssl_protocol
    lb_port            = var.lb_ssl_port
    lb_protocol        = var.lb_ssl_protocol
    ssl_certificate_id = var.ssl_certificate_id
  }

  health_check {
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.health_timeout
    target              = var.health_target
    interval            = var.health_interval
  }

  tags = {
    Name        = "${var.project}-${var.environment}-${var.name}"
    Environment = var.environment
    Project     = var.project
  }
}
