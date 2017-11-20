# terraform_loadbalancers
Terraform modules to set up a number of variants of load balancers.

WARNING: tag `sg-embedded-rules` is the last commit where the security groups contain embedded rules. If you
bump to a version later than this, you will have to refactor the state to match the rules to the `aws_security_group_rule`
resources.

All modules in this repository follow this naming scheme:

```
[alb|elb]_[no|only|with]_ssl_[no|with]_s3logs
```

* type:
   * `alb`: Application Load Balancer
   * `elb`: Elastic Load Balancer
* `ssl`:
   * `no`: no hosting on HTTPS/SSL
   * `only`: only hosting on HTTPS/SSL but no plain HTTP
   * `with`: both HTTP as HTTPS
* `s3logs`:
   * `no`: access logs are not stored in S3
   * `with`: logs are stored on S3

When adding new variants in this repository, make sure they follow this naming scheme.

NOTE: Without conditional logic in Terraform, all variants have to written out explicitely. Once
[terraform#1604](https://github.com/hashicorp/terraform/issues/1604) is resolved, a lot of
this repository will be candidate for a rewrite.

## elb_no_ssl_no_s3logs

### Available variables:
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

### Output
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

### Example
  ```
  module "elb" {
    source                     = "github.com/skyscrapers/terraform-loadbalancers//elb_no_ssl_no_s3logs"
    name                       = "frontend"
    subnets                    = ["${module.vpc.frontend_public_subnets}"]
    project                    = "myapp"
    health_target              = "http:80/health_check"
    backend_security_groups    = ["${module.sg.sg_app_id}"]

  }
  ```

## elb_no_ssl_with_s3logs

### Available variables:
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

### Output
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

### Example
  ```
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

## elb_only_ssl_no_s3logs

### Available variables:
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

### Output
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

### Example
  ```
  module "elb" {
    source                     = "github.com/skyscrapers/terraform-loadbalancers//elb_only_ssl_no_s3logs"
    name                       = "frontend"
    subnets                    = ["${module.vpc.frontend_public_subnets}"]
    project                    = "myapp"
    health_target              = "http:443/health_check"
    backend_security_groups    = ["${module.sg.sg_app_id}"]

  }
  ```

## elb_no_ssl_with_s3logs

### Available variables:
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

### Output
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

### Example
  ```
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

## elb_with_ssl_no_s3logs

### Available variables:
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

### Output
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

### Example
  ```
  module "elb" {
    source                     = "github.com/skyscrapers/terraform-loadbalancers//elb_with_ssl_no_s3logs"
    name                       = "frontend"
    subnets                    = ["${module.vpc.frontend_public_subnets}"]
    project                    = "myapp"
    health_target              = "http:443/health_check"
    backend_security_groups    = ["${module.sg.sg_app_id}"]

  }
  ```

## elb_with_ssl_with_s3logs

### Available variables:
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

### Output
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

### Example
```
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

## alb

Setup an ALB with related resources.

### Available variables

* [`name`]: String(required): Name of the ALB
* [`environment`]: String(required): Environment where this ALB is deployed, eg. staging
* [`project`]: String(required): The current project
* [`vpc_id`]: String(required): The ID of the VPC in which to deploy
* [`internal`]: Bool(optional, false): Is this an internal ALB or not
* [`subnets`]: List(required): Subnets to deploy the ALB in
* [`enable_deletion_protection`]: Bool(optional, false): Whether to enable deletion protection of this ALB or not
* [`access_logs`]: List(optional, []): An ALB access_logs block
* [`tags`]: Map(optional, {}): Optional tags
* [`enable_http_listener`]: Bool(optional, false): Whether to enable the HTTP listener
* [`http_port`]: Int(optional, 80): HTTP port the ALB is listening to
* [`enable_https_listener`]: Bool(optional, true): Whether to enable the HTTPS listener
* [`https_port`]: Int(optional, 443): HTTPS port the ALB is listening to
* [`https_certificate_arn`]: String(required): IAM ARN of the SSL certificate for the HTTPS listener
* [`default_target_group_arn`]: String(optional, ""): Default target group ARN to add to the HTTP listener. Creates a default target group if not set
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
* [`target_security_groups`]: List(required): Security groups of the ALB target instances
* [`target_security_groups_count`]: Int(required): Number of security groups of the ALB target instances
* [`source_subnet_cidrs`]: List(optional, ["0.0.0.0/0"]): Subnet CIDR blocks from where the ALB will receive traffic

### Output

* [`id`]: ID of the ALB
* [`arn`]: ARN of the ALB
* [`name`]: Name of the ALB
* [`dns_name`]: DNS name of the ALB
* [`zone_id`]: DNS zone ID of the ALB
* [`sg_id`]: ID of the ALB security group
* [`http_listener_id`]: ID of the ALB HTTP listener
* [`https_listener_id`]: ID of the ALB HTTPS listener
* [`target_group_arn`]: ID of the default target group

### Example

```terraform
module "alb" {
  source                   = "github.com/skyscrapers/terraform-loadbalancers//alb?ref=1.0.0"
  name                     = "shared"
  environment              = "${terraform.workspace}"
  project                  = "${var.project}"
  vpc_id                   = "${data.terraform_remote_state.shared_static.vpc_id}"
  subnets                  = "${data.terraform_remote_state.shared_static.public_lb_subnets}"
  enable_http_listener     = true
  enable_https_listener    = true
  https_certificate_arn    = "${var.certificate_arn}"
  default_target_group_arn = "${module.web.target_group_arn}"
  target_security_groups   = ["${module.sg.sg_app_id}"]

  access_logs = [{
    bucket = "alb-logs-bucket"
  }]

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
