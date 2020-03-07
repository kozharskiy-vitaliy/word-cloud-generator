FROM golang:latest
RUN apt-get update && apt-get install -y jq openjdk-11-jdk
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/
