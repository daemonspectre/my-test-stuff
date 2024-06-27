#!/bin/bash

apt-get update
apt-get upgrade

ufw allow 80/tcp
ufw allow 53/tcp
ufw allow 53/udp
ufw allow 67/tcp
ufw allow 67/udp
ufw allow 546:547/udp

adduser pihole
usermod -aG sudo pihole

sudo apt install unbound -y
wget https://www.internic.net/domain/named.root -qO- | sudo tee /var/lib/unbound/root.hints

# Define the path to the configuration file
CONFIG_FILE="/etc/unbound/unbound.conf.d/pi-hole.conf"

# Make a backup of the original configuration file
cp $CONFIG_FILE $CONFIG_FILE.bak

# Use sed to edit the configuration file
sed -i 's/do-ip6: no/do-ip6: yes/g' $CONFIG_FILE
sed -i 's/#root-hints: "\/var\/lib\/unbound\/root.hints"/root-hints: "\/var\/lib\/unbound\/root.hints"/g' $CONFIG_FILE
sed -i '/private-address: 192.168.0.0\/16/d' $CONFIG_FILE
sed -i '/private-address: 169.254.0.0\/16/d' $CONFIG_FILE
sed -i '/private-address: 172.16.0.0\/12/d' $CONFIG_FILE
sed -i '/private-address: 10.0.0.0\/8/d' $CONFIG_FILE
echo "private-address: 192.168.0.0/24" >> $CONFIG_FILE

sudo service unbound restart

git clone --depth 1 https://github.com/pi-hole/pi-hole.git Pi-hole
cd "Pi-hole/automated install/"
sudo bash basic-install.sh

pihole -up
