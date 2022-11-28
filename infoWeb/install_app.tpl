#!/bin/bash
sudo yum update -y 
sudo yum install --yes ${application} 
sudo usermod -a -G docker ec2-user
sudo systemctl start docker.service