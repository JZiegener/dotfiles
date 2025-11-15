#!/bin/sh
sudo apt-get update

sudo apt-get install git
git config --global user.email "JZiegener@gmail.com"
git config --global user.name "Jeff Ziegener"
git config --global core.editor "vim"

mkdir ~/repos
cd repos 
git clone https://github.com/JZiegener/dotfiles.git

sudo apt-get install vim
cp ~/repos/dotfiles/vim/.vimrc ~/.vimrc

sudo apt-get install tmux
cp ~/repos/dotfiles/tmux/tmux.conf ~

sudo apt-get install htop

sudo apt-get install curl
sudo apt-get install net-tools

sudo apt-get install software-properties-common

