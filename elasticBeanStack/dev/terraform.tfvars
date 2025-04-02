project-name = "elasticBeanStack"
aws_region = "us-east-1"
 
codebucket = "elasticbeanstack"
file-name = "springdemo2-1.0.0-SNAPSHOT.jar"
file-path = "ansible_templates/files"
app-name = "mywebapp"
webapp-src-location = "/home/vagrant/INFO/springdemo2/target"
#stack-name = "64bit Amazon Linux 2 v4.4.0 running Corretto 17"
stack-name = "64bit Amazon Linux 2023 v4.4.3 running Corretto 21"
instance-profile = "myinstanceprofile"
instance-profile-docker = "myinstanceprofile-docker"


#### beanstack platforms are located here 
#### https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html
dockerstack-name = "64bit Amazon Linux 2 v4.0.7 running Docker"



dockerapp-name = "dockerapp"
dockerwebapp-src-location = "ansible_templates/files"
dockerfile-name = "Dockerrun.aws.zip"
