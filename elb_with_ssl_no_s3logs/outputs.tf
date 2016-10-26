output "elb" {
  value = {
    id =  "${aws_elb.elb.id}"
    name = "${aws_elb.elb.name}"
    fqdn = "${aws_elb.elb.dns_name}"
    source_security_group = "${aws_elb.elb.source_security_group_id}"
    zone_id = "${aws_elb.elb.zone_id}"
  }
}

output "security_group" {
  value = {
    id = "${aws_security_group.elb.id}"
    name = "${aws_security_group.elb.name}"
    description = "${aws_security_group.elb.description}"
    vpc = "${aws_security_group.elb.vpc_id}"
    owner = "${aws_security_group.elb.owner_id}"
    ingres = "${aws_security_group.elb.ingress}"
    egress = "${aws_security_group.elb.egress}"
  }
}
