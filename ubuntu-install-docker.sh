#!/bin/bash

# update and upgrade #
sudo apt-get update && sudo apt-get upgrade -y

# install curl # 
sudo apt-get install curl -y

# curl ca certs #
sudo apt-get install ca-certificates curl

# create dir for keyrings #
sudo install -m 0755 -d /etc/apt/keyrings

# download docker GPG key #
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

# something about permissions #
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources and updates #
sudo echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# install :latestversion of docker #
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# install compose lastest:version #
sudo apt-get update
sudo apt-get install docker-compose-plugin
sudo apt-get full-upgrade -y

# test #
sudo docker run hello-world
sudo docker compose version
