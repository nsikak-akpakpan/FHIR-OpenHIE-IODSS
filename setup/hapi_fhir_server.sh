#bin/sh

docker_ec_user="ec2_user"

#setup using docker
#install docker using yum if not installed
sudo yum update -y
sudo yum install -y docker
sudo service install start

sudo usermod -a -G docker add $docker_ec_user

#setup wothout modifying config
sudo docker run -p 8080:8080 -e hapi.fhir.default-encoding=json hapiproject/hapi:latest

#setup with modified config file
docker run -p 8090:8080 -v $(pwd)/yourLocalFolder:/configs -e "--spring.config.location=file:///configs/another.application.yaml" hapiproject/hapi:latest

#setup using compiled set of resources
docker run -p 8090:8080 -e "--spring.config.location=classpath:/another.application.yaml" hapiproject/hapi:latest

##Running locally
#using jetty
mvn jetty:run

#using a different maven port say on http://localhost:8888/, http://localhost:8888/fhir/metadata.  Adjust overlay config in application.yaml
mvn -Djetty.port=8888 jett:run

#Using Bring Boot with :run
mvn clean spring boot-boot:run -Pboot

#Using Spring boot
mvn clean package spring-boot:repackage -Pboot && java -jar target/ROOT.war

#Using Spring Boot and Google distroless
vn clean package com.google.cloud.tools:jib-maven-plugin:dockerBuild -Dimage=distroless-hapi && docker run -p 8080:8080 distroless-hapi

#Using the Dockerfile and multistage build
./build-docker-image.sh && docker run -p 8080:8080 hapi-fhir/hapi-fhir-jpaserver-starter:latest
