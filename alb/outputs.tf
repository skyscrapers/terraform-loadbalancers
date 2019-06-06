output "id" {
  description = "ID of the ALB"
  value       = aws_lb.alb.id
}

output "arn" {
  description = "ARN of the ALB"
  value       = aws_lb.alb.arn
}

output "dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.alb.dns_name
}

output "zone_id" {
  description = "DNS zone ID of the ALB"
  value       = aws_lb.alb.zone_id
}

output "sg_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.sg_alb.id
}

