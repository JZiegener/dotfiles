#!/bin/sh

sudo apt-get install git -y
mkdir ~/repos
cd repos 
git clone https://github.com/JZiegener/dotfiles.git
cd dotfiles
sudo ./install/install-base-system.sh

cp .bashrc ~/.bashrc
source ~/.bashrc

