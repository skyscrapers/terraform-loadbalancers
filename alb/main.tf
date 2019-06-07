# Create a new load balancer
resource "aws_lb" "alb" {
  load_balancer_type         = "application"
  name                       = "${var.project}-${var.environment}-${var.name_prefix}-alb"
  internal                   = var.internal
  subnets                    = var.subnets
  security_groups            = [aws_security_group.sg_alb.id]
  enable_deletion_protection = var.enable_deletion_protection
  dynamic "access_logs" {
    for_each = [var.access_logs]
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

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
