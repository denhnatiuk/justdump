#!/bin/bash

# Update the package list
sudo apt-get update
sudo apt-get upgrade -y

# Install required softwares
sudo apt-get install mysql-client -y
sudo apt-get install awscli -y

# Install Docker
sudo curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER 
# might need to logout and login again for some docker commands to run.

# setup nginx proxy-server
git clone --recurse-submodules https://github.com/rogdex24/nginx-proxy-automation.git ~/proxy

cd ~/proxy/bin && sudo ./fresh-start.sh --yes -e "info@qressy.com"
