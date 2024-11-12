FROM openjdk:18-jdk-alpine
MAINTAINER Mahesh

# Default value is "development", could be changed by passing other env 
ENV MY_ENV=development 

COPY springdemo2-1.0.0-SNAPSHOT.jar springdemo2-1.0.0-SNAPSHOT.jar

ENTRYPOINT ["java","-jar","/springdemo2-1.0.0-SNAPSHOT.jar"]

