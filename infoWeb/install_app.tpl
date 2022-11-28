#!/bin/bash

yum update -y 
yum install --yes ${application} 
usermod -a -G docker ec2-user
systemctl start docker.service