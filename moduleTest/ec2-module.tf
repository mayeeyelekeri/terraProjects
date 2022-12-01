variable "vpc-cidr" {}
output "vpc" { value = module.vpc-module.vpc-id}