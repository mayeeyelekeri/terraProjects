project-name = "elasticBeanStack"
aws_region = "us-east-1"
 
codebucket = "elasticbeanstack"
file-name = "springdemo-0.0.1-SNAPSHOT.war"
file-path = "ansible_templates/files"
app-name = "mywebapp"
webapp-src-location = "/home/vagrant/springdemo/target"
stack-name = "64bit Amazon Linux 2 v3.4.7 running Corretto 17"
instance-profile = "myinstanceprofile"


#### beanstack platforms are located here 
#### https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html
dockerstack-name = "64bit Amazon Linux 2 v3.5.7 running Docker"



dockerapp-name = "dockerapp"
dockerwebapp-src-location = "ansible_templates/files"
dockerfile-name = "Dockerrun.aws.zip"