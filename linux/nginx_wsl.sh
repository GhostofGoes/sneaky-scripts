#!/usr/bin/env bash
# Install Nginx on WSL
sudo apt -y update
sudo apt -y upgrade
sudo apt install -y wget curl libnss3-tools jq xsel dnsmasq nginx 
sudo mkdir /etc/NetworkManager/dnsmasq.d/
sudo service nginx start
