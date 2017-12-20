# Create a new load balancer
resource "aws_lb" "nlb" {
  load_balancer_type         = "network"
  name_prefix                = "${var.name_prefix}"
  internal                   = "${var.internal}"
  subnets                    = ["${var.subnets}"]
  enable_deletion_protection = "${var.enable_deletion_protection}"

  tags = "${merge("${var.tags}",
    map("Name", "${var.project}-${var.environment}-${var.name_prefix}-alb",
      "Environment", "${var.environment}",
      "Project", "${var.project}"))
  }"
}
