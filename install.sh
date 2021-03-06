#!/usr/bin/env bash
sudo yum remove -y git
sudo wget https://centos7.iuscommunity.org/ius-release.rpm
sudo rpm -Uvh ius-release*rpm
sudo yum install -y git2u yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce
sudo systemctl start docker
sudo yum install -y python-pip
sudo pip install --upgrade-pip
sudo pip install docker-py
sudo pip install ansible-tower-cli
curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
sudo yum -y install nodejs
sudo mkdir -p /pgdocker
sudo mkdir -p /var/lib/awx/projects
sudo chmod -R 777 /var/lib/awx/projects

git clone https://github.com/ansible/awx.git

# Build images locally
sed -i 's/dockerhub_base=ansible/'#dockerhub_base=ansible'/' awx/installer/inventory
sed -i 's/tmp/srv/' awx/installer/inventory
# Fix private IP issue
sed -i '/self.use_private_ip/s/False/True/g' awx/awx/plugins/inventory/azure_rm.py

cd awx/installer
sudo ansible-playbook -i inventory install.yml