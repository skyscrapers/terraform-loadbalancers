output "id" {
  description = "ID of the NLB"
  value       = "${aws_lb.nlb.id}"
}

output "arn" {
  description = "ARN of the NLB"
  value       = "${aws_lb.nlb.arn}"
}

output "dns_name" {
  description = "DNS name of the NLB"
  value       = "${aws_lb.nlb.dns_name}"
}

output "zone_id" {
  description = "DNS zone ID of the NLB"
  value       = "${aws_lb.nlb.zone_id}"
}
