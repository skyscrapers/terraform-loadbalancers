# Create a new load balancer
resource "aws_lb" "nlb" {
  load_balancer_type         = "network"
  name                       = "${var.project}-${var.environment}-${var.name}-nlb"
  internal                   = "${var.internal}"
  subnets                    = ["${var.subnets}"]
  security_groups            = ["${aws_security_group.sg_nlb.id}"]
  enable_deletion_protection = "${var.enable_deletion_protection}"
  access_logs                = ["${var.access_logs}"]

  tags = "${merge("${var.tags}",
    map("Name", "${var.project}-${var.environment}-${var.name}-alb",
      "Environment", "${var.environment}",
      "Project", "${var.project}"))
  }"
}
