#!/bin/bash

sudo apt-get update
sudo apt-get install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

if [-z lspci | grep nvidia] 
then
	sudo apt-get install nvidia-driver
fi

if [-n lspci | grep "VGA compatible controller: Advanced Micro Devices"] &&
   [-z echo /etc/apt/sources | grep sid ]
then
	sudo "deb http://deb.debian.org/debian/ sid main non-free non-free-firmware" >> /etc/apt/sources
	sudo "deb-src http://deb.debian.org/debian/ sid main non-free non-free-firmware" >> /etc/apt/sources
	sudo cp config/amd-drivers-pin /etc/apt/preferences.d/amd-drivers-pin
	sudo apt install firmware-amd-graphics
fi

sudo apt-get install nfs-common
sudo apt-get install lm-sensors
sudo apt-get install htop
sudo apt-get install powertop
sudo apt-get install vim
cp ~/repos/dotfiles/vim/.vimrc ~/.vimrc
sudo apt-get install curl
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible
#Other repos
#VS Codium
flatpak install flathub vscodium -y
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension EditorConfig.EditorConfig
code --install-extension golang.go
code --install-extension esbenp.prettier-vscode
#Spotify
flatpak install flathub spotify -y

sudo apt-get install tmux
cp ~/repos/dotfiles/tmux/tmux.conf ~
flatpak install flathub firefox

sudo mkdir -p /etc/firefox/policies
sudo cp ~/repos/dotfiles/install/config/firefox-policies.json /etc/firefox/policies/policies.json

git config --global user.email "JZiegener@gmail.com"
git config --global user.name "Jeff Ziegener"
git config --global core.editor "vim"

flatpak install flathub discord
#add sid repo
