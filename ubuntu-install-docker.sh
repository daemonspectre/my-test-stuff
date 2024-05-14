#!/bin/bash

# update and upgrade #
sudo apt-get update && sudo apt-get upgrade -y

# install curl # 
sudo apt-get install curl -y

# curl ca certs #
curl ca-certificates

# create dir for keyrings #
install -m 0755 -d /etc/apt/keyrings

# download docker GPG key #
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

# something about permissions #
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources and updates #
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# install :latestversion of docker #
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# install compose lastest:version #
sudo apt-get update
sudo apt-get install docker-compose-plugin

# This command creates a new user with a home directory and sets the default shell to bash #
sudo useradd -m -s /bin/bash Docker

# Add the new user to the docker group to grant permission to run Docker commands #
sudo usermod -aG docker Docker

# make user password #
sudo passwd Docker

# user login #
su - Docker

# test #
docker run hello-world
docker compose version
