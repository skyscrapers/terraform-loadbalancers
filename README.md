# Terraform Load Balancer Modules

Terraform modules to set up a number of variants of load balancers.

WARNING: tag `sg-embedded-rules` is the last commit where the security groups contain embedded rules. If you
bump to a version later than this, you will have to refactor the state to match the rules to the `aws_security_group_rule`
resources.

## alb

Setup an ALB with related resources.

### Available variables

* [`name_prefix`]: String(required): Name prefix of the ALB and security group
* [`environment`]: String(required): Environment where this ALB is deployed, eg. staging
* [`project`]: String(required): The current project
* [`vpc_id`]: String(required): The ID of the VPC in which to deploy
* [`internal`]: Bool(optional, false): Is this an internal ALB or not
* [`subnets`]: List(required): Subnets to deploy the ALB in
* [`enable_deletion_protection`]: Bool(optional, false): Whether to enable deletion protection of this ALB or not
* [`access_logs`]: List(optional, []): An ALB access_logs block
* [`tags`]: Map(optional, {}): Optional tags

### Output

* [`id`]: ID of the ALB
* [`arn`]: ARN of the ALB
* [`dns_name`]: DNS name of the ALB
* [`zone_id`]: DNS zone ID of the ALB
* [`sg_id`]: ID of the ALB security group

### Example

```hcl
module "alb" {
  source                   = "github.com/skyscrapers/terraform-loadbalancers//alb?ref=5.0.0"
  name_prefix              = "shared"
  environment              = "${terraform.workspace}"
  project                  = "${var.project}"
  vpc_id                   = "${data.terraform_remote_state.shared_static.vpc_id}"
  subnets                  = "${data.terraform_remote_state.shared_static.public_lb_subnets}"

  access_logs = [{
    bucket = "alb-logs-bucket"
  }]

  tags = {
    Role = "loadbalancer"
  }
}
```

## alb_listener

### Available variables

* [`name_prefix`]: String(required): Name prefix of the ALB listener
* [`environment`]: String(required): Environment where this ALB is deployed, eg. staging
* [`project`]: String(required): The current project
* [`vpc_id`]: String(required): The ID of the VPC in which to deploy
* [`alb_arn`]: String(required): ARN of the ALB on which this listener will be attached.
* [`alb_sg_id`]: String(required): ID of the security group attached to the load balancer
* [`default_target_group_arn`]: String(optional, ""): Default target group ARN to add to the HTTP listener. Creates a default target group if not set
* [`ingress_port`]: Int(optional, -1): Ingress port the ALB is listening to
* [`https_certificate_arn`]: String(optional, ""): IAM ARN of the SSL certificate for the HTTPS listener
* [`target_port`]: Int(optional, 80): The port of which targets receive traffic
* [`target_protocol`]: String(optional, "HTTP"): The protocol to sue for routing traffic to the targets
* [`target_deregistration_delay`]: Int(optional, 30): The time in seconds before deregistering the target
* [`target_stickiness`]: List(optional, []): An ALB target_group stickiness block
* [`target_health_interval`]: Int(optional, 30): Time in seconds between target health checks
* [`target_health_path`]: String(optional, "/"): Path for the health check request
* [`target_health_timeout`]: Int(optional, 5): Time in seconds to wait for a successful health check response
* [`target_health_healthy_threshold`]: Int(optional, 5): The number of consecutive health checks successes before considering a target healthy
* [`target_health_unhealthy_threshold`]: Int(optional, 2): The number of consecutive health check failures before considering a target unhealthy
* [`target_health_matcher`]: Int(optional, 200): The HTTP codes to use when checking for a successful response from a target
* [`source_subnet_cidrs`]: List(optional, ["0.0.0.0/0"]): Subnet CIDR blocks from where the ALB will receive traffic
* [`tags`]: Map(optional, {}): Optional tags

### Output

* [`listener_id`]: ID of the ALB HTTP/HTTPS listener
* [`target_group_arn`]: ID of the default target group

### Example

```hcl
module "alb_listener_https" {
  source                = "github.com/skyscrapers/terraform-loadbalancers//alb_listener?ref=5.0.0"
  environment           = "${terraform.workspace}"
  project               = "${var.project}"
  vpc_id                = "${data.terraform_remote_state.static.vpc_id}"
  name_prefix           = "def"
  alb_arn               = "${module.alb.arn}"
  alb_sg_id             = "${module.alb.sg_id}"
  https_certificate_arn = "${var.alb_certificate_arn}"

  target_stickiness = [{
    type = "lb_cookie"
  }]

  tags = {
    Role = "loadbalancer"
  }
}

```

## alb\_rule\_target

Create an ALB listener\_rule and attached target\_group

*Future work:*

Add support for registering additional certificates on an LB listener from the `alb_rule_target` module. 
While adding certificates on an ALB listener is supported in the console/cli/sdk, it is not yet integrated 
in the Terraform AWS provider. Request was filed as https://github.com/terraform-providers/terraform-provider-aws/issues/1853 
and the corresponding PR is https://github.com/terraform-providers/terraform-provider-aws/pull/2686

### Available variables

* [`name`]: String(required): Name of the ALB
* [`environment`]: String(required): Environment where this ALB is deployed, eg. staging
* [`project`]: String(required): The current project
* [`vpc_id`]: String(required): The ID of the VPC in which to deploy
* [`listener_arn`]: String(required): The ARN of the listener to which to attach the rule
* [`listener_priority`]: Int(required): The priority for the rule
* [`listener_condition_field`]: String(optional, \"path-pattern\"): Must be one of `path-pattern` for path based routing or `host-header` for host based routing
* [`listener_condition_values`]: List(required): The path or host patterns to match. A maximum of 1 can be defined
* [`target_port`]: Int(optional, 80): The port of which targets receive traffic
* [`target_protocol`]: String(optional, "HTTP"): The protocol to sue for routing traffic to the targets
* [`target_deregistration_delay`]: Int(optional, 30): The time in seconds before deregistering the target
* [`target_stickiness`]: List(optional, []): An ALB target_group stickiness block
* [`target_health_interval`]: Int(optional, 30): Time in seconds between target health checks
* [`target_health_path`]: String(optional, "/"): Path for the health check request
* [`target_health_timeout`]: Int(optional, 5): Time in seconds to wait for a successful health check response
* [`target_health_healthy_threshold`]: Int(optional, 5): The number of consecutive health checks successes before considering a target healthy
* [`target_health_unhealthy_threshold`]: Int(optional, 2): The number of consecutive health check failures before considering a target unhealthy
* [`target_health_matcher`]: Int(optional, 200): The HTTP codes to use when checking for a successful response from a target
* [`target_health_protocol`]: String(optional, HTTP): The protocol to use for the healthcheck
* [`tags`]: Map(optional, {}): Optional tags

### Output

* [`target_group_arn`]: ID of the target group

### Example

```terraform
module "target" {
  source                    = "github.com/skyscrapers/terraform-loadbalancers//alb_rule_target_rule?ref=1.0.0"
  name                      = "web"
  environment               = "${terraform.workspace}"
  project                   = "${var.project}"
  vpc_id                    = "${data.terraform_remote_state.shared_static.vpc_id}"
  listener_arn              = "${module.alb.https_listener_id}"
  listener_priority         = 100
  listener_condition_field  = "host-header"
  listener_condition_values = ["${var.web_url}"]
  target_port               = "${var.app_port}"

  target_stickiness = [{
    type = "lb_cookie"
  }]

  tags = {
    Role = "loadbalancer"
  }
}
```

## nlb

Setup an NLB with related resources.

### Available variables

* [`name_prefix`]: String(required): Name prefix of the NLB and security group
* [`environment`]: String(required): Environment where this NLB is deployed, eg. staging
* [`project`]: String(required): The current project
* [`vpc_id`]: String(required): The ID of the VPC in which to deploy
* [`internal`]: Bool(optional, false): Is this an internal NLB or not
* [`subnets`]: List(required): Subnets to deploy the NLB in
* [`enable_deletion_protection`]: Bool(optional, false): Whether to enable deletion protection of this NLB or not
* [`tags`]: Map(optional, {}): Optional tags

### Output

* [`id`]: ID of the NLB
* [`arn`]: ARN of the NLB
* [`dns_name`]: DNS name of the NLB
* [`zone_id`]: DNS zone ID of the NLB
* [`sg_id`]: ID of the NLB security group

### Example

```hcl
module "nlb" {
  source                   = "github.com/skyscrapers/terraform-loadbalancers//nlb?ref=5.0.0"
  name                     = "shared"
  environment              = "${terraform.workspace}"
  project                  = "${var.project}"
  vpc_id                   = "${data.terraform_remote_state.shared_static.vpc_id}"
  subnets                  = "${data.terraform_remote_state.shared_static.public_lb_subnets}"

  tags = {
    Role = "loadbalancer"
  }
}
```

## alb_listener

### Available variables

* [`name_prefix`]: String(required): Name prefix of the NLB listener
* [`environment`]: String(required): Environment where this NLB is deployed, eg. staging
* [`project`]: String(required): The current project
* [`vpc_id`]: String(required): The ID of the VPC in which to deploy
* [`nlb_arn`]: String(required): ARN of the NLB on which this listener will be attached.
* [`nlb_sg_id`]: String(required): ID of the security group attached to the load balancer
* [`default_target_group_arn`]: String(optional, ""): Default target group ARN to add to the HTTP listener. Creates a default target group if not set
* [`ingress_port`]: Int(optional, -1): Ingress port the NLB is listening to
* [`target_port`]: Int(optional, 80): The port of which targets receive traffic
* [`target_deregistration_delay`]: Int(optional, 30): The time in seconds before deregistering the target
* [`target_health_interval`]: Int(optional, 30): Time in seconds between target health checks
* [`target_health_timeout`]: Int(optional, 5): Time in seconds to wait for a successful health check response
* [`target_health_healthy_threshold`]: Int(optional, 5): The number of consecutive health checks successes before considering a target healthy
* [`target_health_unhealthy_threshold`]: Int(optional, 2): The number of consecutive health check failures before considering a target unhealthy
* [`source_subnet_cidrs`]: List(optional, ["0.0.0.0/0"]): Subnet CIDR blocks from where the NLB will receive traffic
* [`tags`]: Map(optional, {}): Optional tags

### Output

* [`listener_id`]: ID of the NLB HTTP/HTTPS listener
* [`target_group_arn`]: ID of the default target group

### Example

```hcl
module "nlb_listener_concourse_workers" {
  source                       = "github.com/skyscrapers/terraform-loadbalancers//nlb_listener?ref=5.0.0"
  environment           = "${terraform.workspace}"
  project               = "${var.project}"
  vpc_id                = "${data.terraform_remote_state.static.vpc_id}"
  name_prefix           = "def"
  nlb_arn               = "${module.nlb.arn}"
  nlb_sg_id             = "${module.nlb.sg_id}"
  ingress_port          = 4800

  tags = {
    Role = "loadbalancer"
  }
}
```

## Deprecated modules

### elb_no_ssl_no_s3logs

#### Available variables:

 * [`name`]: String(required): Name of the ELB
 * [`subnets`]: List(required): A list of subnet IDs to attach to the ELB.
 * [`project`]: String(required): The current project
 * [`health_target`]: String(required): The target of the check. Valid pattern is ${PROTOCOL}:${PORT}${PATH}
 * [`environment`]: String(required): How do you want to call your environment, this is helpful if you have more than 1 VPC.
 * [`backend_security_groups`]: List(required): The security groups of the ELB backends instances
 * [`internal`]: Boolean(optional):default to false. If true, ELB will be an internal ELB.
 * [`idle_timeout`]: Integer(optional):default 60. The time in seconds that the connection is allowed to be idle.
 * [`connection_draining`]: Boolean(optional):default true. Boolean to enable connection draining.
 * [`connection_draining_timeout`]: String(optional):default 60. The time in seconds to allow for connections to drain
 * [`instance_port`]: Integer(optional):default 80. The port on the instance to route to
 * [`instance_protocol`]: String(optional):default http. The protocol to use to the instance. Valid values are HTTP, HTTPS, TCP, or SSL"
 * [`lb_port`]: Integer(optional):default 80. The port to listen on for the load balancer
 * [`lb_protocol`]: String(optional):default http. The protocol to listen on. Valid values are HTTP, HTTPS, TCP, or SSL
 * [`healthy_threshold`]: Integer(optional):default 3. The number of checks before the instance is declared healthy.
 * [`unhealthy_threshold`]: Integer(optional):default 2. The number of checks before the instance is declared unhealthy.
 * [`health_timeout`]: Integer(optional):default 3. The length of time before the check times out.
 * [`health_interval`]: Integer(optional):default 30. The interval between checks.
 * [`ingoing_allowed_ips`]: List(optional):default 0.0.0.0/0. What IP's are allowed to access the ELB

#### Output

 * [`elb_id`]: String: The id of the ELB
 * [`elb_name`]: String: The name of the ELB
 * [`elb_dns_name`]: String: The DNS name of the ELB
 * [`elb_source_security_group_id`]: String: The ID of the security group that you can use as part of your inbound rules for your load balancer's back-end application instances.
 * [`elb_zone_id`]: String: The canonical hosted zone ID of the ELB (to be used in a Route 53 Alias record)
 * [`sg_id`]: String: The ID of the security group
 * [`sg_vpc_id`]: String: The VPC ID.
 * [`sg_owner_id`]: String: The owner ID.
 * [`sg_name`]: String: The name of the security group
 * [`sg_description`]: String: The description of the security group
 * [`sg_ingress`]: Map: The ingress rules.
 * [`sg_egress`]: Map: The egress rules.

#### Example

```hcl
module "elb" {
  source                     = "github.com/skyscrapers/terraform-loadbalancers//elb_no_ssl_no_s3logs"
  name                       = "frontend"
  subnets                    = ["${module.vpc.frontend_public_subnets}"]
  project                    = "myapp"
  health_target              = "http:80/health_check"
  backend_security_groups    = ["${module.sg.sg_app_id}"]

}
```

### elb_no_ssl_with_s3logs

#### Available variables

 * [`name`]: String(required): Name of the ELB
 * [`subnets`]: List(required): A list of subnet IDs to attach to the ELB.
 * [`project`]: String(required): The current project
 * [`health_target`]: String(required): The target of the check. Valid pattern is ${PROTOCOL}:${PORT}${PATH}
 * [`access_logs_bucket`]: String(required): The S3 bucket name to store the logs in.
 * [`environment`]: String(required): How do you want to call your environment, this is helpful if you have more than 1 VPC.
 * [`backend_security_groups`]: List(required): The security groups of the ELB backends instances
 * [`internal`]: Boolean(optional):default to false. If true, ELB will be an internal ELB.
 * [`idle_timeout`]: Integer(optional):default 60. The time in seconds that the connection is allowed to be idle.
 * [`connection_draining`]: Boolean(optional):default true. Boolean to enable connection draining.
 * [`connection_draining_timeout`]: String(optional):default 60. The time in seconds to allow for connections to drain
 * [`access_logs_bucket_prefix`]: String(optional):default empty. The S3 bucket prefix. Logs are stored in the root if not configured.
 * [`access_logs_interval`]: String(optional):default 60. The publishing interval in minutes.
 * [`access_logs_enabled`]: Boolean(optional):default true. Whether or not to enable the access logs
 * [`instance_port`]: Integer(optional):default 80. The port on the instance to route to
 * [`instance_protocol`]: String(optional):default http. The protocol to use to the instance. Valid values are HTTP, HTTPS, TCP, or SSL"
 * [`lb_port`]: Integer(optional):default 80. The port to listen on for the load balancer
 * [`lb_protocol`]: String(optional):default http. The protocol to listen on. Valid values are HTTP, HTTPS, TCP, or SSL
 * [`healthy_threshold`]: Integer(optional):default 3. The number of checks before the instance is declared healthy.
 * [`unhealthy_threshold`]: Integer(optional):default 2. The number of checks before the instance is declared unhealthy.
 * [`health_timeout`]: Integer(optional):default 3. The length of time before the check times out.
 * [`health_interval`]: Integer(optional):default 30. The interval between checks.

#### Output

 * [`elb_id`]: String: The id of the ELB
 * [`elb_name`]: String: The name of the ELB
 * [`elb_dns_name`]: String: The DNS name of the ELB
 * [`elb_source_security_group_id`]: String: The ID of the security group that you can use as part of your inbound rules for your load balancer's back-end application instances.
 * [`elb_zone_id`]: String: The canonical hosted zone ID of the ELB (to be used in a Route 53 Alias record)
 * [`sg_id`]: String: The ID of the security group
 * [`sg_vpc_id`]: String: The VPC ID.
 * [`sg_owner_id`]: String: The owner ID.
 * [`sg_name`]: String: The name of the security group
 * [`sg_description`]: String: The description of the security group
 * [`sg_ingress`]: Map: The ingress rules.
 * [`sg_egress`]: Map: The egress rules.

#### Example

```hcl
module "elb" {
  source                    = "github.com/skyscrapers/terraform-loadbalancers//elb_no_ssl_with_s3logs"
  name                      = "frontend"
  subnets                   = ["${module.vpc.frontend_public_subnets}"]
  project                   = "myapp"
  health_target             = "http:80/health_check"
  access_logs_bucket        = "elb_logs"
  access_logs_bucket_prefix = "myapp/frontend/"
  backend_security_groups   = ["${module.sg.sg_app_id}"]
}
```

### elb_only_ssl_no_s3logs

#### Available variables

 * [`name`]: String(required): Name of the ELB
 * [`subnets`]: List(required): A list of subnet IDs to attach to the ELB.
 * [`project`]: String(required): The current project
 * [`health_target`]: String(required): The target of the check. Valid pattern is ${PROTOCOL}:${PORT}${PATH}
 * [`environment`]: String(required): How do you want to call your environment, this is helpful if you have more than 1 VPC.
 * [`backend_security_groups`]: List(required): The security groups of the ELB backend instances
 * [`ssl_certificate_id`]: String(required): The ARN of an SSL certificate you have uploaded to AWS IAM.
 * [`internal`]: Boolean(optional):default to false. If true, ELB will be an internal ELB.
 * [`idle_timeout`]: Integer(optional):default 60. The time in seconds that the connection is allowed to be idle.
 * [`connection_draining`]: Boolean(optional):default true. Boolean to enable connection draining.
 * [`connection_draining_timeout`]: String(optional):default 60. The time in seconds to allow for connections to drain
 * [`instance_ssl_port`]: Integer(optional):default 443. The port on the instance to route to
 * [`instance_ssl_protocol`]: String(optional):default http. The protocol to use to the instance. Valid values are HTTP, HTTPS, TCP, or SSL"
 * [`lb_ssl_port`]: Integer(optional):default 443. The port to listen on for the load balancer
 * [`lb_ssl_protocol`]: String(optional):default https. The protocol to listen on. Valid values are HTTP, HTTPS, TCP, or SSL
 * [`healthy_threshold`]: Integer(optional):default 3. The number of checks before the instance is declared healthy.
 * [`unhealthy_threshold`]: Integer(optional):default 2. The number of checks before the instance is declared unhealthy.
 * [`health_timeout`]: Integer(optional):default 3. The length of time before the check times out.
 * [`health_interval`]: Integer(optional):default 30. The interval between checks.

#### Output

 * [`elb_id`]: String: The id of the ELB
 * [`elb_name`]: String: The name of the ELB
 * [`elb_dns_name`]: String: The DNS name of the ELB
 * [`elb_source_security_group_id`]: String: The ID of the security group that you can use as part of your inbound rules for your load balancer's back-end application instances.
 * [`elb_zone_id`]: String: The canonical hosted zone ID of the ELB (to be used in a Route 53 Alias record)
 * [`sg_id`]: String: The ID of the security group
 * [`sg_vpc_id`]: String: The VPC ID.
 * [`sg_owner_id`]: String: The owner ID.
 * [`sg_name`]: String: The name of the security group
 * [`sg_description`]: String: The description of the security group
 * [`sg_ingress`]: Map: The ingress rules.
 * [`sg_egress`]: Map: The egress rules.

#### Example

```hcl
module "elb" {
  source                     = "github.com/skyscrapers/terraform-loadbalancers//elb_only_ssl_no_s3logs"
  name                       = "frontend"
  subnets                    = ["${module.vpc.frontend_public_subnets}"]
  project                    = "myapp"
  health_target              = "http:443/health_check"
  backend_security_groups    = ["${module.sg.sg_app_id}"]

}
```

### elb_no_ssl_with_s3logs

#### Available variables

 * [`name`]: String(required): Name of the ELB
 * [`subnets`]: List(required): A list of subnet IDs to attach to the ELB.
 * [`project`]: String(required): The current project
 * [`health_target`]: String(required): The target of the check. Valid pattern is ${PROTOCOL}:${PORT}${PATH}
 * [`access_logs_bucket`]: String(required): The S3 bucket name to store the logs in.
 * [`environment`]: String(required): How do you want to call your environment, this is helpful if you have more than 1 VPC.
 * [`backend_security_groups`]: List(required): The security groups of the ELB backends instances
 * [`internal`]: Boolean(optional):default to false. If true, ELB will be an internal ELB.
 * [`idle_timeout`]: Integer(optional):default 60. The time in seconds that the connection is allowed to be idle.
 * [`connection_draining`]: Boolean(optional):default true. Boolean to enable connection draining.
 * [`connection_draining_timeout`]: String(optional):default 60. The time in seconds to allow for connections to drain
 * [`access_logs_bucket_prefix`]: String(optional):default empty. The S3 bucket prefix. Logs are stored in the root if not configured.
 * [`access_logs_interval`]: String(optional):default 60. The publishing interval in minutes.
 * [`access_logs_enabled`]: Boolean(optional):default true. Whether or not to enable the access logs
 * [`instance_ssl_port`]: Integer(optional):default 443. The port on the instance to route to
 * [`instance_ssl_protocol`]: String(optional):default http. The protocol to use to the instance. Valid values are HTTP, HTTPS, TCP, or SSL"
 * [`lb_ssl_port`]: Integer(optional):default 443. The port to listen on for the load balancer
 * [`lb_ssl_protocol`]: String(optional):default https. The protocol to listen on. Valid values are HTTP, HTTPS, TCP, or SSL
 * [`healthy_threshold`]: Integer(optional):default 3. The number of checks before the instance is declared healthy.
 * [`unhealthy_threshold`]: Integer(optional):default 2. The number of checks before the instance is declared unhealthy.
 * [`health_timeout`]: Integer(optional):default 3. The length of time before the check times out.
 * [`health_interval`]: Integer(optional):default 30. The interval between checks.

#### Output

 * [`elb_id`]: String: The id of the ELB
 * [`elb_name`]: String: The name of the ELB
 * [`elb_dns_name`]: String: The DNS name of the ELB
 * [`elb_source_security_group_id`]: String: The ID of the security group that you can use as part of your inbound rules for your load balancer's back-end application instances.
 * [`elb_zone_id`]: String: The canonical hosted zone ID of the ELB (to be used in a Route 53 Alias record)
 * [`sg_id`]: String: The ID of the security group
 * [`sg_vpc_id`]: String: The VPC ID.
 * [`sg_owner_id`]: String: The owner ID.
 * [`sg_name`]: String: The name of the security group
 * [`sg_description`]: String: The description of the security group
 * [`sg_ingress`]: Map: The ingress rules.
 * [`sg_egress`]: Map: The egress rules.

#### Example

```hcl
module "elb" {
  source                    = "github.com/skyscrapers/terraform-loadbalancers//elb_only_ssl_with_s3logs"
  name                      = "frontend"
  subnets                   = ["${module.vpc.frontend_public_subnets}"]
  project                   = "myapp"
  health_target             = "http:443/health_check"
  access_logs_bucket        = "elb_logs"
  access_logs_bucket_prefix = "myapp/frontend/"
  backend_security_groups   = ["${module.sg.sg_app_id}"]

}
```

### elb_with_ssl_no_s3logs

#### Available variables

 * [`name`]: String(required): Name of the ELB
 * [`subnets`]: List(required): A list of subnet IDs to attach to the ELB.
 * [`project`]: String(required): The current project
 * [`health_target`]: String(required): The target of the check. Valid pattern is ${PROTOCOL}:${PORT}${PATH}
 * [`environment`]: String(required): How do you want to call your environment, this is helpful if you have more than 1 VPC.
 * [`backend_security_groups`]: List(required): The security groups of the ELB backends instances
 * [`internal`]: Boolean(optional):default to false. If true, ELB will be an internal ELB.
 * [`idle_timeout`]: Integer(optional):default 60. The time in seconds that the connection is allowed to be idle.
 * [`connection_draining`]: Boolean(optional):default true. Boolean to enable connection draining.
 * [`connection_draining_timeout`]: String(optional):default 60. The time in seconds to allow for connections to drain
 * [`instance_port`]: Integer(optional):default 80. The port on the instance to route to
 * [`instance_protocol`]: String(optional):default http. The protocol to use to the instance. Valid values are HTTP, HTTPS, TCP, or SSL"
 * [`lb_port`]: Integer(optional):default 80. The port to listen on for the load balancer
 * [`lb_protocol`]: String(optional):default http. The protocol to listen on. Valid values are HTTP, HTTPS, TCP, or SSL
 * [`instance_ssl_port`]: Integer(optional):default 443. The port on the instance to route to
 * [`instance_ssl_protocol`]: String(optional):default http. The protocol to use to the instance. Valid values are HTTP, HTTPS, TCP, or SSL"
 * [`lb_ssl_port`]: Integer(optional):default 443. The port to listen on for the load balancer
 * [`lb_ssl_protocol`]: String(optional):default https. The protocol to listen on. Valid values are HTTP, HTTPS, TCP, or SSL
 * [`healthy_threshold`]: Integer(optional):default 3. The number of checks before the instance is declared healthy.
 * [`unhealthy_threshold`]: Integer(optional):default 2. The number of checks before the instance is declared unhealthy.
 * [`health_timeout`]: Integer(optional):default 3. The length of time before the check times out.
 * [`health_interval`]: Integer(optional):default 30. The interval between checks.

#### Output

 * [`elb_id`]: String: The id of the ELB
 * [`elb_name`]: String: The name of the ELB
 * [`elb_dns_name`]: String: The DNS name of the ELB
 * [`elb_source_security_group_id`]: String: The ID of the security group that you can use as part of your inbound rules for your load balancer's back-end application instances.
 * [`elb_zone_id`]: String: The canonical hosted zone ID of the ELB (to be used in a Route 53 Alias record)
 * [`sg_id`]: String: The ID of the security group
 * [`sg_vpc_id`]: String: The VPC ID.
 * [`sg_owner_id`]: String: The owner ID.
 * [`sg_name`]: String: The name of the security group
 * [`sg_description`]: String: The description of the security group
 * [`sg_ingress`]: Map: The ingress rules.
 * [`sg_egress`]: Map: The egress rules.

#### Example

```hcl
module "elb" {
  source                     = "github.com/skyscrapers/terraform-loadbalancers//elb_with_ssl_no_s3logs"
  name                       = "frontend"
  subnets                    = ["${module.vpc.frontend_public_subnets}"]
  project                    = "myapp"
  health_target              = "http:443/health_check"
  backend_security_groups    = ["${module.sg.sg_app_id}"]

}
```

### elb_with_ssl_with_s3logs

#### Available variables

 * [`name`]: String(required): Name of the ELB
 * [`subnets`]: List(required): A list of subnet IDs to attach to the ELB.
 * [`project`]: String(required): The current project
 * [`health_target`]: String(required): The target of the check. Valid pattern is ${PROTOCOL}:${PORT}${PATH}
 * [`access_logs_bucket`]: String(required): The S3 bucket name to store the logs in.
 * [`environment`]: String(required): How do you want to call your environment, this is helpful if you have more than 1 VPC.
 * [`backend_security_groups`]: List(required): The security group of the ELB backends instances
 * [`internal`]: Boolean(optional):default to false. If true, ELB will be an internal ELB.
 * [`idle_timeout`]: Integer(optional):default 60. The time in seconds that the connection is allowed to be idle.
 * [`connection_draining`]: Boolean(optional):default true. Boolean to enable connection draining.
 * [`connection_draining_timeout`]: String(optional):default 60. The time in seconds to allow for connections to drain
 * [`access_logs_bucket_prefix`]: String(optional):default empty. The S3 bucket prefix. Logs are stored in the root if not configured.
 * [`access_logs_interval`]: String(optional):default 60. The publishing interval in minutes.
 * [`access_logs_enabled`]: Boolean(optional):default true. Whether or not to enable the access logs
 * [`instance_port`]: Integer(optional):default 80. The port on the instance to route to
 * [`instance_protocol`]: String(optional):default http. The protocol to use to the instance. Valid values are HTTP, HTTPS, TCP, or SSL"
 * [`lb_port`]: Integer(optional):default 80. The port to listen on for the load balancer
 * [`lb_protocol`]: String(optional):default http. The protocol to listen on. Valid values are HTTP, HTTPS, TCP, or SSL
 * [`instance_ssl_port`]: Integer(optional):default 443. The port on the instance to route to
 * [`instance_ssl_protocol`]: String(optional):default http. The protocol to use to the instance. Valid values are HTTP, HTTPS, TCP, or SSL"
 * [`lb_ssl_port`]: Integer(optional):default 443. The port to listen on for the load balancer
 * [`lb_ssl_protocol`]: String(optional):default https. The protocol to listen on. Valid values are HTTP, HTTPS, TCP, or SSL
 * [`healthy_threshold`]: Integer(optional):default 3. The number of checks before the instance is declared healthy.
 * [`unhealthy_threshold`]: Integer(optional):default 2. The number of checks before the instance is declared unhealthy.
 * [`health_timeout`]: Integer(optional):default 3. The length of time before the check times out.
 * [`health_interval`]: Integer(optional):default 30. The interval between checks.

#### Output

 * [`elb_id`]: String: The id of the ELB
 * [`elb_name`]: String: The name of the ELB
 * [`elb_dns_name`]: String: The DNS name of the ELB
 * [`elb_source_security_group_id`]: String: The ID of the security group that you can use as part of your inbound rules for your load balancer's back-end application instances.
 * [`elb_zone_id`]: String: The canonical hosted zone ID of the ELB (to be used in a Route 53 Alias record)
 * [`sg_id`]: String: The ID of the security group
 * [`sg_vpc_id`]: String: The VPC ID.
 * [`sg_owner_id`]: String: The owner ID.
 * [`sg_name`]: String: The name of the security group
 * [`sg_description`]: String: The description of the security group
 * [`sg_ingress`]: Map: The ingress rules.
 * [`sg_egress`]: Map: The egress rules.

#### Example

```hcl
module "elb" {
  source                    = "github.com/skyscrapers/terraform-loadbalancers//elb_with_ssl_with_s3logs"
  name                      = "frontend"
  subnets                   = ["${module.vpc.frontend_public_subnets}"]
  project                   = "myapp"
  health_target             = "http:443/health_check"
  access_logs_bucket        = "elb_logs"
  access_logs_bucket_prefix = "myapp/frontend/"
  backend_security_groups   = ["${module.sg.sg_app_id}"]

}
```
