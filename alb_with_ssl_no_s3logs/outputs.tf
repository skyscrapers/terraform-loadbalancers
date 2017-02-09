output "alb_id" {
  value = "${aws_alb.alb.id}"
}
output "arn" {
  value = "${aws_alb.alb.arn}"
}
output "sg_id" {
  value = "${aws_security_group.sg_alb.id}"
}

output "https_listener" {
  value = "${aws_alb_listener.https.id}"
}

output "target_group_arn" {
  value = "${aws_alb_target_group.https_target_group.arn}"
}
