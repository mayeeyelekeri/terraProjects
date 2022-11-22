FROM openjdk:8-jdk-alpine
MAINTAINER mahesh

EXPOSE 8080

COPY ./springdemo.war springdemo.war 

ENTRYPOINT ["java", "-jar", "/springdemo.war"]