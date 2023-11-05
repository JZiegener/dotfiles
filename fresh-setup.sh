#!/bin/sh
sudo apt-get install git -y
mkdr ~/repos
cd repos 
git clone https://github.com/JZiegener/dotfiles.git
cd dotfiles
sudo ./install/install-base-system.sh

cp .bashrc ~/.bashrc
source ~/.bashrc

ssh-keygen -t ed25519 -C "JZiegener@gmail.com"
ssh-add ~/.ssh/id_ed25519