resource "aws_security_group" "sg_nlb" {
  name_prefix = "${var.name_prefix}"
  description = "Security group for NLB ${var.project}-${var.environment}-${var.name_prefix}-nlb"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge("${var.tags}",
    map("Name", "${var.project}-${var.environment}-${var.name_prefix}-sg_nlb",
      "Environment", "${var.environment}",
      "Project", "${var.project}"))
  }"
}
