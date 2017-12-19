# Create a new load balancer
resource "aws_lb" "alb" {
  load_balancer_type         = "application"
  name_prefix                = "${var.name_prefix}"
  internal                   = "${var.internal}"
  subnets                    = ["${var.subnets}"]
  security_groups            = ["${aws_security_group.sg_alb.id}"]
  enable_deletion_protection = "${var.enable_deletion_protection}"
  access_logs                = ["${var.access_logs}"]

  tags = "${merge("${var.tags}",
    map("Name", "${var.project}-${var.environment}-${var.name_prefix}-alb",
      "Environment", "${var.environment}",
      "Project", "${var.project}"))
  }"
}
