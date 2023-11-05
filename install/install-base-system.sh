#!/bin/sh

sudo apt-get update
sudo apt-get install flatpak
sudo apt-get install nfs-common
sudo apt-get install lm-sensors
sudo apt-get install htop
sudo apt-get install powertop
sudo apt-get install vim
sudo apt-get install curl
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
#Other repos
#VS Vodium
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main'     | sudo tee /etc/apt/sources.list.d/vscodium.list
#Spotify
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client
sudo apt-get install tmux
cp ~/repos/dotfiles/tmux/tmux.conf ~
flatpack install firefox
sudo mkdir -p /etc/firefox/policies
sudo cp ~/repos/dotfiles/install/config/firefox-policies.json /etc/firefox/policies/policies.json