FROM golang:latest
USER root
RUN apt-get update && apt-get install -y jq openjdk-11-jdk
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/
RUN apt-get update && apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
gnupg2 \
software-properties-common \
&& curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - \
&& add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/debian \
$(lsb_release -cs) \
stable" \
&& apt-get update && apt-get install docker-ce docker-ce-cli containerd.io
