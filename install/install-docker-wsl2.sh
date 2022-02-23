#!/bin/bash

# From https://dev.to/felipecrs/simply-run-docker-on-wsl2-3o8 
# and https://dev.to/bowmanjd/install-docker-on-windows-wsl-without-docker-desktop-34m9


# Ensures not older packages are installed
sudo apt-get remove docker docker-engine docker.io containerd runc

# Ensure pre-requisites are installed
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Adds docker apt repository
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" |
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Adds docker apt key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
    sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Refreshes apt repos
sudo apt-get update

# Installs Docker CE
sudo apt-get install docker-ce docker-ce-cli containerd.io

# Ensures docker group exists
sudo groupadd docker

# Ensures you are part of it
sudo usermod -aG docker $USER

# Finds the latest version
compose_version=$(curl -fsSL -o /dev/null -w "%{url_effective}" https://github.com/docker/compose/releases/latest | xargs basename)

# Downloads the binary to the plugins folder
curl -fL --create-dirs -o ~/.docker/cli-plugins/docker-compose \
    "https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-linux-$(uname -m)"

# Assigns execution permission to it
chmod +x ~/.docker/cli-plugins/docker-compose