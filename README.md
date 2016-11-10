# terraform_loadbalancers
Terraform modules to set up a number of variants of load balancers.

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
 * [`backend_security_group`]: String(required): The security group of the ELB backend instances
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
    source        = "github.com/skyscrapers/terraform-loadbalancers//elb_no_ssl_no_s3logs"
    name          = "frontend"
    subnets       = ["${module.vpc.frontend_public_subnets}"]
    project       = "myapp"
    health_target = "http:80/health_check"
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
 * [`backend_security_group`]: String(required): The security group of the ALB backend instances
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
  }
  ```

## elb_only_ssl_no_s3logs

### Available variables:
 * [`name`]: String(required): Name of the ELB
 * [`subnets`]: List(required): A list of subnet IDs to attach to the ELB.
 * [`project`]: String(required): The current project
 * [`health_target`]: String(required): The target of the check. Valid pattern is ${PROTOCOL}:${PORT}${PATH}
 * [`environment`]: String(required): How do you want to call your environment, this is helpful if you have more than 1 VPC.
 * [`backend_security_group`]: String(required): The security group of the ALB backend instances
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
    source        = "github.com/skyscrapers/terraform-loadbalancers//elb_only_ssl_no_s3logs"
    name          = "frontend"
    subnets       = ["${module.vpc.frontend_public_subnets}"]
    project       = "myapp"
    health_target = "http:443/health_check"
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
 * [`backend_security_group`]: String(required): The security group of the ALB backend instances
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
  }
  ```

## elb_with_ssl_no_s3logs

### Available variables:
 * [`name`]: String(required): Name of the ELB
 * [`subnets`]: List(required): A list of subnet IDs to attach to the ELB.
 * [`project`]: String(required): The current project
 * [`health_target`]: String(required): The target of the check. Valid pattern is ${PROTOCOL}:${PORT}${PATH}
 * [`environment`]: String(required): How do you want to call your environment, this is helpful if you have more than 1 VPC.
 * [`backend_security_group`]: String(required): The security group of the ALB backend instances
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
    source        = "github.com/skyscrapers/terraform-loadbalancers//elb_with_ssl_no_s3logs"
    name          = "frontend"
    subnets       = ["${module.vpc.frontend_public_subnets}"]
    project       = "myapp"
    health_target = "http:443/health_check"
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
 * [`backend_security_group`]: String(required): The security group of the ALB backend instances
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
  }
  ```
