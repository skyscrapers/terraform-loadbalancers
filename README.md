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

## alb_with_ssl_no_s3logs

### Available variables:
 * [`name`]: String(required): Name of the ALB
 * [`vpc_id`]: String(required): ID of the VPC where to deploy in 
 * [`backend_security_group`]: String(optional): The security group of the ALB backend instances
 * [`subnets`]: List(required): Subnets to deploy in
 * [`internal`]: Boolean(optional): Is it an internal ALB or not
 * [`lb_port`]: Integer(optional): Port the ALB is listening to
 * [`lb_ssl_port`]: Integer(optional): Port the ALB is listening to with SSL enabled
 * [`ssl_certificate_id`]: String(required): IAM ID of the SSL certificate if needed
 * [`environment`]: String(optional): How do you want to call your environment, this is helpful if you have more than 1 VPC.
 * [`project`]: String(required): The current project
 * [`default_target_group`]: String(required): default target group for http and https listeners
 * [`source_subnets`]: List(required): Subnets from where the ALB will receive the traffic

### Output
 * [`alb_id`]: String: The id of the created Application Load Balancer.
 * [`sg_id`]: String: The id of the created security group attached to the ALB.
 * [`http_listener`]: String: The id of the HTTP listener of the ALB.
 * [`https_listener`]: String: The id of the HTTPS listener of the ALB.

### Example
  ```
  module "my_alb" {
    source = "github:skyscrapers/terraform_loadbalancers?ref=<commit>"
    vpc_id="${module.vpc.vpc_id}"
    subnets="${module.vpc.public_lb_subnets}"
    internal=false
    ssl_certificate_id="arn:acm::<id_of_certificate>"
    name="my_alb"
    environment="staging"
    project="customer_name"
    default_target_group="some_application_tg"
  }
  ```

## elb_no_ssl_with_s3logs

### Available variables:
 * [`name`]: String(required): Name of the ELB
 * [`subnets`]: List(required): A list of subnet IDs to attach to the ELB.
 * [`project`]: String(required): The current project
 * [`environment`]: String(optional): How do you want to call your environment, this is helpful if you have more than 1 VPC.
 * [`backend_security_group`]: String(optional): The security group of the ALB backend instances
 * [`internal`]: Boolean(optional): If true, ELB will be an internal ELB.
 * [`idle_timeout`]: Integer(optional): The time in seconds that the connection is allowed to be idle.
 * [`connection_draining`]: Boolean(optional): Boolean to enable connection draining.
 * [`connection_draining_timeout`]: String(optional): The time in seconds to allow for connections to drain
 * [`access_logs_bucket`]: String(required): The S3 bucket name to store the logs in. 
 * [`access_logs_bucket_prefix`]: String(optional): The S3 bucket prefix. Logs are stored in the root if not configured. 
 * [`access_logs_interval`]: String(optional): The publishing interval in minutes. 
 * [`access_logs_enabled`]: Boolean(optional): Whether or not to enable the access logs 
 * [`lb_port`]: Integer(optional): The port to listen on for the load balancer 
 * [`lb_protocol`]: String(optional): The protocol to listen on. Valid values are HTTP, HTTPS, TCP, or SSL 
 * [`healthy_threshold`]: Integer(optional): The number of checks before the instance is declared healthy. 
 * [`unhealthy_threshold`]: Integer(optional): The number of checks before the instance is declared unhealthy. 
 * [`health_timeout`]: Integer(optional): The length of time before the check times out. 
 * [`health_target`]: String(required): The target of the check. Valid pattern is ${PROTOCOL}:${PORT}${PATH} 
 * [`health_interval`]: Integer(optional): The interval between checks. 

### Output
 * [`elb_id`]: List: 
 * [`elb_name`]: List: 
 * [`elb_dns_name`]: List: 
 * [`elb_source_security_group_id`]: List: 
 * [`elb_zone_id`]: List: 
 * [`sg_id`]: List: 
 * [`sg_vpc_id`]: List: 
 * [`sg_owner_id`]: List: 
 * [`sg_name`]: List: 
 * [`sg_description`]: List: 
 * [`sg_ingress`]: List: 
 * [`sg_egress`]: List: 

### Example
  ```
  module "nat_gateway" {
    source = "nat_gateway"
    private_route_tables="${module.vpc.private_rts}"
    public_subnets="${module.vpc.public_subnets}"
  }
  ```

## elb_with_ssl_no_s3logs

### Available variables:
 * [`private_route_tables`]: List(required): 
 * [`number_nat_gateways`]: String(optional): 
 * [`public_subnets`]: List(required): 

### Output
 * [`ids`]: List: The ids of the nat gateways created.

### Example
  ```
  module "nat_gateway" {
    source = "nat_gateway"
    private_route_tables="${module.vpc.private_rts}"
    public_subnets="${module.vpc.public_subnets}"
  }
  ```

