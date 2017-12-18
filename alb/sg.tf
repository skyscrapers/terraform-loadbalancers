resource "aws_security_group" "sg_alb" {
  name        = "sg_alb_${var.project}_${var.environment}_${var.name}"
  description = "Security group for ALB ${var.project}-${var.environment}-${var.name}-alb"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge("${var.tags}",
    map("Name", "${var.project}-${var.environment}-${var.name}-sg_alb",
      "Environment", "${var.environment}",
      "Project", "${var.project}"))
  }"
}
