output "elb_id" {
  value = aws_elb.elb.id
}

output "elb_name" {
  value = aws_elb.elb.name
}

output "elb_dns_name" {
  value = aws_elb.elb.dns_name
}

output "elb_source_security_group_id" {
  value = aws_elb.elb.source_security_group_id
}

output "elb_zone_id" {
  value = aws_elb.elb.zone_id
}

output "sg_id" {
  value = aws_security_group.elb.id
}

output "sg_vpc_id" {
  value = aws_security_group.elb.vpc_id
}

output "sg_owner_id" {
  value = aws_security_group.elb.owner_id
}

output "sg_name" {
  value = aws_security_group.elb.name
}

output "sg_description" {
  value = aws_security_group.elb.description
}

output "sg_ingress" {
  value = aws_security_group.elb.ingress
}

output "sg_egress" {
  value = aws_security_group.elb.egress
}

