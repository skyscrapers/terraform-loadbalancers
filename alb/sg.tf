resource "aws_security_group" "sg_alb" {
  name_prefix = var.name_prefix
  description = "Security group for ALB ${var.project}-${var.environment}-${var.name_prefix}-alb"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      "Name"        = "${var.project}-${var.environment}-${var.name_prefix}-sg_alb"
      "Environment" = var.environment
      "Project"     = var.project
    },
  )
}

