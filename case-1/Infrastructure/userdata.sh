#!/bin/bash
set -e

# =========================
# DISK EXPANSION (OPTIONAL)
# =========================
dnf install -y cloud-utils-growpart xfsprogs lvm2

growpart /dev/nvme0n1 4 || true
lvextend -L +30G /dev/mapper/RootVG-homeVol || true
xfs_growfs /home || true


# =========================
# SYSTEM UPDATE
# =========================
dnf update -y


# =========================
# INSTALL JAVA (Jenkins dependency)
# =========================
dnf install -y java-17-amazon-corretto


# =========================
# INSTALL JENKINS
# =========================
dnf install -y wget

wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

dnf install -y jenkins

systemctl enable jenkins
systemctl start jenkins


# =========================
# INSTALL DOCKER
# =========================
dnf install -y docker

systemctl enable docker
systemctl start docker

# Add Jenkins + ec2-user to docker group
usermod -aG docker jenkins
usermod -aG docker ec2-user


# =========================
# INSTALL GIT
# =========================
dnf install -y git


# =========================
# INSTALL UNZIP (required for AWS CLI)
# =========================
dnf install -y unzip curl


# =========================
# INSTALL AWS CLI v2
# =========================
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip

unzip awscliv2.zip
./aws/install

rm -rf aws awscliv2.zip


# =========================
# ENABLE SERVICES
# =========================
systemctl restart jenkins
systemctl restart docker


# =========================
# FINAL STATUS CHECK (LOG)
# =========================
echo "Jenkins status:"
systemctl status jenkins --no-pager

echo "Docker status:"
systemctl status docker --no-pager

echo "Setup completed successfully"