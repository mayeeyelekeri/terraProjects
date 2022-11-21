output "Elastic Bean Stack application" {
	value	  = aws_elastic_beanstalk_application.mywebapp
} 

output "bucket" {
	value = aws_elastic_beanstalk_application_version.beanstalk_myapp_version.name
}