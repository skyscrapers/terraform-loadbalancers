resource "aws_alb_listener_rule" "rule" {
  listener_arn = var.listener_arn
  priority     = var.listener_priority

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.target.arn
  }

  condition {
    field  = var.listener_condition_field
    values = var.listener_condition_values
  }
}

resource "aws_alb_target_group" "target" {
  name                 = "${var.project}-${var.environment}-${var.name}"
  port                 = var.target_port
  protocol             = var.target_protocol
  vpc_id               = var.vpc_id
  deregistration_delay = var.target_deregistration_delay
  dynamic "stickiness" {
    for_each = var.target_stickiness
    content {
      cookie_duration = lookup(stickiness.value, "cookie_duration", null)
      enabled         = lookup(stickiness.value, "enabled", null)
      type            = stickiness.value.type
    }
  }
  target_type = var.target_type

  health_check {
    interval            = var.target_health_interval
    path                = var.target_health_path
    timeout             = var.target_health_timeout
    healthy_threshold   = var.target_health_healthy_threshold
    unhealthy_threshold = var.target_health_unhealthy_threshold
    matcher             = var.target_health_matcher
    protocol            = var.target_health_protocol == "" ? var.target_protocol : var.target_health_protocol
  }

  tags = merge(
    var.tags,
    {
      "Name"        = "${var.project}-${var.environment}-${var.name}"
      "Environment" = var.environment
      "Project"     = var.project
    },
  )
}
