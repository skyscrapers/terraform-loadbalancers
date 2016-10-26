output "alb" {
  value = {
    id = "${aws_alb.alb.id}"
    listeners = {
      http = "${aws_alb_listener.http.id}"
      https = "${aws_alb_listener.https.id}"
    }
  }
}