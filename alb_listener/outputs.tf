output "listener_id" {
  description = "ID of the ALB HTTP/HTTPS listener"
  value       = aws_lb_listener.listener.id
}

output "target_group_arn" {
  description = "ID of the default target group"
  value       = join(" ", aws_lb_target_group.default.*.arn)
}

