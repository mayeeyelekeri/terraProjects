
/* --------------------------------------------
 Following actions are perfomed in "VPC" module
 1) Create VPC  
 2) Create Internet gateway and attach it to VPC  
 3) Create Public subnets (by default its private)
 4) Create Route table and attach IG to it 
 5) Associate all public subnets to Route table 
 6) Create security group for public access 
 7) Create Private Subnets 
 8) Create Nat Gateway 
 9) Create Route table for private route 
 10) Associate route table to all Private subnets 
 11) Attach NAT gateway to all private route  
-------------------------------------------------------- */ 
module "vpc" {
    source = "../modules/vpc"
    
    # Pass all the variable values to the vpc module 
    aws_region         = var.aws_region
    open_cidr          = var.open_cidr 
    vpc_cidr           = var.vpc_cidr 
    public_subnet_map  = var.public_subnet_map
    private_subnet_map = var.private_subnet_map

    # ----- OUTPUTS ------ 
    # vpc_id,vpc_name, public_subnets, private_subnets, public_sg_id, private_sg_id, nat_gateway_id
}

/* --------------------------------------------
 Following actions are perfomed in the lambda module
 1) Create Role for Lambda  
 2) Create zip file for lambda function 
 3) Create Lambda function
-------------------------------------------------------- */ 
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambda_function.zip"
  function_name = var.function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.10"

  environment {
    variables = {
      myname = "MM"
    }
  }
}