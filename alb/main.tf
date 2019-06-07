# Create a new load balancer
resource "aws_lb" "alb" {
  load_balancer_type         = "application"
  name                       = "${var.project}-${var.environment}-${var.name_prefix}"
  internal                   = var.internal
  subnets                    = var.subnets
  security_groups            = [aws_security_group.sg_alb.id]
  enable_deletion_protection = var.enable_deletion_protection
  dynamic "access_logs" {
    for_each = [var.access_logs]
    content {
      bucket  = access_logs.value.bucket
      enabled = lookup(access_logs.value, "enabled", null)
      prefix  = lookup(access_logs.value, "prefix", null)
    }
  }

  tags = merge(
    var.tags,
    {
      "Name"        = "${var.project}-${var.environment}-${var.name_prefix}-alb"
      "Environment" = var.environment
      "Project"     = var.project
    },
  )
}
