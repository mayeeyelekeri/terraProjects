variable "vpc-cidr" {}
variable "public-subnet-cidr-list" { type = list }
variable "public-subnet-availability-zone-list" {type = list}

variable "private-subnet-map" { type = map }
variable "private-subnet2-map" { type = map }