resource "aws_security_group" "sg_alb" {
  name        = "${var.project}-${var.environment}-${var.name_prefix}-sg-alb"
  description = "Security group for ALB ${var.project}-${var.environment}-${var.name_prefix}-alb"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge("${var.tags}",
    map("Name", "${var.project}-${var.environment}-${var.name_prefix}-sg-alb",
      "Environment", "${var.environment}",
      "Project", "${var.project}"))
  }"
}
