#!/bin/sh

sudo apt-get update
sudo apt-get install nvidia-driver
sudo apt-get install flatpak
if ($XDG_CURRENT_DESKTOP == "GNOME")
    sudo apt-get install gnome-software-plugin-flatpak
fi
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

sudo apt-get install nfs-common
sudo apt-get install lm-sensors
sudo apt-get install htop
sudo apt-get install powertop
sudo apt-get install vim
cp ~/repos/dotfiles/vim/.vimrc ~/.vimrc
sudo apt-get install curl
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible
#Other repos
#VS Vodium
flatpak install flathub vscodium -y
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