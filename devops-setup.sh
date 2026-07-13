#!/bin/bash

set -e

echo "Updating system..."
sudo apt update
sudo apt install -y \
curl wget git unzip zip gnupg lsb-release software-properties-common \
apt-transport-https ca-certificates jq python3 python3-pip \
openjdk-21-jdk maven gradle awscli

echo "Installing Docker..."
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER

echo "Installing kubectl (ARM64)..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo "Installing Minikube (ARM64)..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm64
sudo install minikube-linux-arm64 /usr/local/bin/minikube
rm minikube-linux-arm64

echo "Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "Installing Terraform..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | \
sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
sudo apt install -y terraform

echo "Installing Ansible..."
sudo apt install -y ansible

echo "Installing Azure CLI..."
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

echo "Installing Node.js LTS..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

echo "Installing Jenkins..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | \
sudo tee /usr/share/keyrings/jenkins-keyring.asc >/dev/null

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" | \
sudo tee /etc/apt/sources.list.d/jenkins.list >/dev/null

sudo apt update
sudo apt install -y jenkins

sudo systemctl enable docker
sudo systemctl start docker

sudo systemctl enable jenkins
sudo systemctl start jenkins

echo
echo "==========================================="
echo "Installation Complete!"
echo "==========================================="
echo "Git:        $(git --version)"
echo "Docker:     $(docker --version)"
echo "kubectl:    $(kubectl version --client)"
echo "Minikube:   $(minikube version)"
echo "Terraform:  $(terraform version | head -1)"
echo "Ansible:    $(ansible --version | head -1)"
echo "AWS CLI:    $(aws --version)"
echo "Azure CLI:  $(az version | head -1 || true)"
echo "Helm:       $(helm version --short)"
echo "Java:       $(java -version 2>&1 | head -1)"
echo "Maven:      $(mvn -version | head -1)"
echo "Gradle:     $(gradle --version | head -2 | tail -1)"
echo "Node:       $(node -v)"
echo "npm:        $(npm -v)"
echo
echo "Jenkins: http://localhost:8080"
echo "Initial Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword || true
