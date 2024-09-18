#!/bin/bash
docker ps 
docker ps -aqf "name=springdemo2"  |xargs docker rm -f  | echo "removed any old running containers(if any)"
docker ps 
