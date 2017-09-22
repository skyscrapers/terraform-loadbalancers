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

## alb_with_ssl_no_s3logs

### Available variables:
 * [`name`]: String(required): Name of the ALB
 * [`subnets`]: List(required): A list of subnet IDs to attach to the ALB.
 * [`project`]: String(required): The current project
 * [`vpc_id`]: String(required): ID of the VPC where to deploy in
 * [`environment`]: String(required): How do you want to call your environment, this is helpful if you have more than 1 VPC.
 * [`backend_security_groups`]: List(required): The security groups of the ALB backends instances
 * [`internal`]: Boolean(optional):default to false. If true, ALB will be an internal ALB.
 * [`connection_draining`]: Boolean(optional):default true. Boolean to enable connection draining.
 * [`deregistration_delay`]: String(optional):default 30. The time in seconds to allow before deregistering
 * [`http_port`]: Integer(optional):default 80. The http alb port
 * [`https_port`]: Integer(optional):default 443. The https alb port
 * [`ssl_certificate_id`]: String(optional):IAM ID of the SSL certificate
 * [`backend_http_port`]: String(optional):default 80. The port to send http traffic
 * [`backend_https_port`]: String(optional):default 8443. The port to send https traffic
 * [`backend_http_protocol`]: String(optional):default HTTP. The protocol of the backend for http listener
 * [`backend_https_protocol`]: String(optional):default HTTP. The protocol of the backend for https listener
 * [`source_subnets`]: List(optional):default 0.0.0.0/0. Subnets cidr blocks from where the ALB will receive the traffic
 * [`https_interval`]: String(optional) default 30, The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds.
 * [`https_path`]: String(optional) default /, The destination for the health check request.
 * [`https_timeout`]: String(optional) default 5, The amount of time, in seconds, during which no response means a failed health check.
 * [`https_healthy_threshold`]: String(optional) default 5, The number of consecutive health checks successes required before considering an unhealthy target healthy.
 * [`https_unhealthy_threshold`]: String(optional) default 2, The number of consecutive health check failures required before considering the target unhealthy.
 * [`https_matcher`]: String(optional) default 200, The HTTP codes to use when checking for a successful response from a target.


### Output
 * [`alb_id`]: String: The id of the ALB
 * [`alb_name`]: String: The name of the ALB
 * [`sg_id`]: String: The security group of the ALB
 * [`https_listener`]: String: The id of the https listener
 * [`http_listener`]: String: The id of the http listener
 * [`target_group_arns`]: List: the list of arns of the target groups created
 * [`dns_name`]: String: The DNS name of the load balancer.
 * [`zone_id`]: String: The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)

### Example

```
module "alb" {
  source                  = "github.com/skyscrapers/terraform-loadbalancers//alb_with_ssl_no_s3logs"
  vpc_id                  = "${var.vpc_id}"
  backend_security_groups = ["${module.sg.sg_app_id}"]
  subnets                 = "${var.lb_subnets}"
  ssl_certificate_id      = "${var.ssl_certificate_id}"
  project                 = "${var.project}"
  environment             = "${var.environment}"
  name                    = "${var.app_name}"
}
```

## alb_no_ssl_no_s3logs

### Available variables:
 * [`name`]: String(required): Name of the ALB
 * [`subnets`]: List(required): A list of subnet IDs to attach to the ALB.
 * [`project`]: String(required): The current project
 * [`vpc_id`]: String(required): ID of the VPC where to deploy in
 * [`environment`]: String(required): How do you want to call your environment, this is helpful if you have more than 1 VPC.
 * [`backend_security_groups`]: List(required): The security group of the ALB backend instances
 * [`internal`]: Boolean(optional):default to false. If true, ALB will be an internal ALB.
 * [`connection_draining`]: Boolean(optional):default true. Boolean to enable connection draining.
 * [`deregistration_delay`]: String(optional):default 30. The time in seconds to allow before deregistering
 * [`http_port`]: Integer(optional):default 80. The http alb port
 * [`ssl_certificate_id`]: String(optional):IAM ID of the SSL certificate
 * [`backend_http_port`]: String(optional):default 80. The port to send http traffic
 * [`backend_http_protocol`]: String(optional):default HTTP. The protocol of the backend for http listener
 * [`source_subnets`]: List(optional):default 0.0.0.0/0. Subnets cidr blocks from where the ALB will receive the traffic
 * [`http_interval`]: String(optional) default 30, The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds.
 * [`http_path`]: String(optional) default /, The destination for the health check request.
 * [`http_timeout`]: String(optional) default 5, The amount of time, in seconds, during which no response means a failed health check.
 * [`http_healthy_threshold`]: String(optional) default 5, The number of consecutive health checks successes required before considering an unhealthy target healthy.
 * [`http_unhealthy_threshold`]: String(optional) default 2, The number of consecutive health check failures required before considering the target unhealthy.
 * [`http_matcher`]: String(optional) default 200, The HTTP codes to use when checking for a successful response from a target.


### Output
 * [`alb_id`]: String: The id of the ALB
 * [`sg_id`]: String: The security group of the ALB
 * [`http_listener`]: String: The id of the http listener
 * [`target_group_arns`]: List: the list of arns of the target groups created

### Example

```
module "alb" {
  source                  = "github.com/skyscrapers/terraform-loadbalancers//alb_no_ssl_no_s3logs"
  vpc_id                  = "${var.vpc_id}"
  backend_security_groups = ["${module.sg.sg_app_id}"]
  subnets                 = "${var.lb_subnets}"
  ssl_certificate_id      = "${var.ssl_certificate_id}"
  project                 = "${var.project}"
  environment             = "${var.environment}"
  name                    = "${var.app_name}"
}
```
