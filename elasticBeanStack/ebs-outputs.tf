output "aws_elastic_beanstalk_environment" {
	value	  = aws_elastic_beanstalk_environment.myapp-env.endpoint_url
} 

output "aws_elastic_beanstalk_docker-environment" {
	value	  = aws_elastic_beanstalk_environment.dockerapp-env.endpoint_url
} 

output "bucket" {
	value = aws_elastic_beanstalk_application_version.beanstalk_myapp_version.name
}