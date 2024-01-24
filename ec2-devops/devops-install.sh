#!/bin/bash

sudo yum update -y
sudo yum install -y wget unzip

# installation git
sudo yum install -y git

# installation docker
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -aG docker ec2-user

# installation kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# installation eksctl
sudo wget https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz
sudo tar -xvf eksctl_Linux_amd64.tar.gz -C /usr/local/bin

# installation helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod +x get_helm.sh
./get_helm.sh

# installation Terraform
sudo wget https://releases.hashicorp.com/terraform/1.7.0/terraform_1.7.0_linux_amd64.zip
sudo unzip terraform_1.7.0_linux_amd64.zip -d /usr/local/bin/

