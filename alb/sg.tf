resource "aws_security_group" "sg_alb" {
  name_prefix = var.name_prefix
  name        = var.name != null ? "${var.project}-${var.environment}-${var.name}-sg_alb" : null
  description = "Security group for ALB ${var.project}-${var.environment}-${local.name}-alb"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      "Name"        = "${var.project}-${var.environment}-${local.name}-sg_alb"
      "Environment" = var.environment
      "Project"     = var.project
    },
  )
}
