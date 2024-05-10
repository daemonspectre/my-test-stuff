#!/bin/bash

# update and upgrade #
apt-get update && sudo apt-get upgrade -y

# install curl # 
apt-get install curl -y

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
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# install compose lastest:version #
apt-get update
apt-get install docker-compose-plugin

# verify docker and compose install #
docker run hello-world
docker compose version
