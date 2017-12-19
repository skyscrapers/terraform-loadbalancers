resource "aws_security_group" "sg_nlb" {
  name        = "sg_alb_${var.project}_${var.environment}_${var.name}"
  description = "Security group for NLB ${var.project}-${var.environment}-${var.name}-nlb"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge("${var.tags}",
    map("Name", "${var.project}-${var.environment}-${var.name}-sg_nlb",
      "Environment", "${var.environment}",
      "Project", "${var.project}"))
  }"
}
