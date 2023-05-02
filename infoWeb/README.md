<!-- BEGIN_TF_DOCS -->
## Requirements

Source code for project Client and SpringDataTest
Bucket for storing state files. 

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

|    Name    | Location   | Description                        |
|----------  | ---------- | -----------------------------------|
| VPC        | ../modules | VPC, subnets, security groups      | 
| ALB        | ../modules | ALB                                | 
| codebuild  | ../modules |                                    | 
| codedeploy | ../modules |                                    | 
| autoscale  | autoscale  |                                    | 

### Resources

| Name | Type |
|------|------|
| none | 

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|



## Outputs

| Name | Description |
|------|-------------|

<!-- END_TF_DOCS -->
