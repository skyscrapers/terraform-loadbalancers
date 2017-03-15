output "alb_id" {
  value = "${aws_alb.alb.id}"
}
output "arn" {
  value = "${aws_alb.alb.arn}"
}
output "sg_id" {
  value = "${aws_security_group.sg_alb.id}"
}

output "http_listener" {
  value = "${aws_alb_listener.http.id}"
}

output "target_group_arn" {
  value = "${aws_alb_target_group.http_target_group.arn}"
}
