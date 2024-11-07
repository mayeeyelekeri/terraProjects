resource "aws_vpc" "vpc" {
  count = "2"

  cidr_block           = "10.0.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true

  lifecycle { 
    precondition { 
      condition  = "${count.index}" <= 1 
      error_message = "first one"
    }
  }

  provisioner "local-exec" { 
     command = "echo creating/modifying vpc >> vpcs" 
  }

  tags = {
    Name = "${terraform.workspace} -10.0.0.0/24 ${count.index}"
    AnotherTag = join ("-" , ["vpc", "${count.index}"]) 
  }
}


resource "aws_vpc" "vpc2" {
  for_each = toset(["dev","test"])

  cidr_block           = "10.0.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${terraform.workspace}-10.0.0.0/24"
    Environment = each.key
    IsItZero = timestamp() 
  }
}
