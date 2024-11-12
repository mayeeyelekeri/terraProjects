#!/bin/bash
pwd 
id 
ls -lrt /tmp 
ls -lrt ~
echo $HOME
cd /tmp; docker build -t springdemo2:latest .
docker run --name springdemo2 -p 8080:8080 -d springdemo2:latest 
