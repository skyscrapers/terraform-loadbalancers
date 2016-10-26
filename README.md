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

Please refer to the variant README.md for variables and outputs of that variant.
