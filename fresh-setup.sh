#!/bin/sh
ssh-keygen -t ed25519 -C "JZiegener@gmail.com" -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1
ssh-add ~/.ssh/id_ed25519

sudo apt-get install git -y
mkdir ~/repos
cd repos 
git clone https://github.com/JZiegener/dotfiles.git
cd dotfiles
sudo ./install/install-base-system.sh

cp .bashrc ~/.bashrc
source ~/.bashrc

