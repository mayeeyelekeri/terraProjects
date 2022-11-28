#!/bin/bash
sudo yum update -y 
sudo yum install -y ${application} 
sudo usermod -a -G docker ec2-user
sudo systemctl start docker.service

sudo yum install -y ruby 
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install 
chmod a+x ./install 
sudo ./install auto -v releases/codedeploy-agent-1.4.1-2244.noarch.rpm

