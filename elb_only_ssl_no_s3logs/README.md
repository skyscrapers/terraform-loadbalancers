# elb_ssl terraform module
this module sets up an ELB with listeners for normal traffic and ssl traffic.

## Generated resources
- elb
- security group

## Required variables
### project
- String
- The current project this elb is used in.

### environment
- String
- The environment the elb is deployed in

### name
- String
- Name of the resource

### internal
- Boolean
- If true, ELB will be an internal ELB.

### backend_sg
- List
- A list of security groups belonging to the backend instances

### ssl_certificate_id
- String
- The ARN of an SSL certificate you have uploaded to AWS IAM. Only valid when lb_protocol is either HTTPS or SSL

### health_target
- String
- The target of the health check. Valid pattern is ${PROTOCOL}:${PORT}${PATH}

## Optional variables

### subnets
- List
- A list of subnet IDs to attach to the ELB.

### idle_timeout
- Int
- Default: 60
- The time in seconds that the connection is allowed to be idle.

### connection_draining
- Boolean
- Default: true
- Boolean to enable connection draining.

### connection_draining_timeout
- Int
- Default: 60
- The time in seconds to allow for connections to drain.

### instance_ssl_port
- Int
- Default: 443
- The port on the instance to route to

### instance_ssl_protocol
- String
- Default: "https"
- The protocol to use to the instance. Valid values are HTTP, HTTPS, TCP, or SSL

### lb_ssl_port
- Int
- Default: 443
- The port to listen on for the load balancer

### lb_ssl_protocol
- String
- Default: "https"
- The protocol to listen on. Valid values are HTTP, HTTPS, TCP, or SSL

### healthy_threshold
- Int
- Default: 3
- The number of checks before the instance is declared healthy.

### unhealthy_threshold
- Int
- Default: 2
- The number of checks before the instance is declared unhealthy.

### health_timeout
- Int
- Default: 3
- The length of time before the check times out.

### health_interval
- Int
- Default: 30
- The interval between checks.

## Outputs
### elb_id
- String
- The name of the ELB

### elb_name
  - String
  - The name of the ELB

### elb_dns_name
- String
- The DNS name of the ELB

### elb_source_security_group_id
- String
- The ID of the security group that you can use as part of your inbound rules for your load balancer's back-end application instances.

### elb_zone_id
- String
- The canonical hosted zone ID of the ELB (to be used in a Route 53 Alias record)

### sg_id
- String
- The ID of the security group

### sg_vpc_id
- String
- The VPC ID.

### sg_owner_id
- String
- The owner ID.

### sg_name
- String
- The name of the security group

### sg_description
- String
- The description of the security group

### sg_ingress
- Map
- The ingress rules.

### sg_egress
- Map
- The egress rules.
