output "id" {
  description = "ID of the ALB"
  value       = "${aws_alb.alb.id}"
}

output "arn" {
  description = "ARN of the ALB"
  value       = "${aws_alb.alb.arn}"
}

output "name" {
  description = "Name of the ALB"
  value       = "${aws_alb.alb.name}"
}

output "dns_name" {
  description = "DNS name of the ALB"
  value       = "${aws_alb.alb.dns_name}"
}

output "zone_id" {
  description = "DNS zone ID of the ALB"
  value       = "${aws_alb.alb.zone_id}"
}

output "sg_id" {
  description = "ID of the ALB security group"
  value       = "${aws_security_group.sg_alb.id}"
}

output "http_listener_id" {
  description = "ID of the ALB HTTP listener"
  value       = "${aws_alb_listener.https.id}"
}

output "https_listener_id" {
  description = "ID of the ALB HTTPS listener"
  value       = "${aws_alb_listener.https.id}"
}

output "target_group_arn" {
  description = "ID of the default target group"
  value       = "${aws_alb_target_group.default.arn}"
}
