#!/bin/bash
set -e

# =========================
# DISK EXPANSION (OPTIONAL)
# =========================
sudo growpart /dev/nvme0n1 4
sudo pvresize /dev/nvme0n1p4
sudo lvextend -L +20G /dev/mapper/RootVG-varVol
sudo xfs_growfs /var

# =========================
# INSTALL JENKINS
# =========================
sudo curl -o /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
# Add required dependencies for the jenkins package
sudo yum install fontconfig java-21-openjdk -y
sudo yum install jenkins -y
sudo systemctl daemon-reload

# =========================
# INSTALL DOCKER
# =========================
dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user












