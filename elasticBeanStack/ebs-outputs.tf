output "elastic_Bean_Stack_application" {
	value	  = aws_elastic_beanstalk_application.mywebapp
} 

output "bucket" {
	value = aws_elastic_beanstalk_application_version.beanstalk_myapp_version.name
}