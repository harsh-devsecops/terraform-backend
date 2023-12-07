FROM jenkins/jenkins:latest
USER root
RUN apt-get update && \
    apt-get install -y unzip && \
    curl -O https://releases.hashicorp.com/terraform/0.15.0/terraform_0.15.0_linux_amd64.zip && \
    unzip terraform_0.15.0_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_0.15.0_linux_amd64.zip
USER jenkins
