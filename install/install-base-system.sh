#!/bin/bash

sudo apt-get update
sudo apt-get install nvidia-driver
sudo apt-get install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

if [ $XDG_CURRENT_DESKTOP = "GNOME" ]
then 
  echo "Running GNOME config"
  sudo apt-get install gnome-software-plugin-flatpak
  gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark 
  gsettings set org.gnome.desktop.interface color-scheme prefer-dark
  array=("https://extensions.gnome.org/extension/120/system-monitor/"
  "https://extensions.gnome.org/extension/1034/services-systemd/"
  "https://extensions.gnome.org/extension/750/openweather/"
  "https://extensions.gnome.org/extension/3193/blur-my-shell/"
  "https://extensions.gnome.org/extension/1460/vitals/" )

  for i in "${array[@]}"
  do
     EXTENSION_ID=$(curl -s $i | grep -oP 'data-uuid="\K[^"]+')
     VERSION_TAG=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=$EXTENSION_ID" | jq '.extensions[0] | .shell_version_map | map(.pk) | max')
     wget -O ${EXTENSION_ID}.zip "https://extensions.gnome.org/download-extension/${EXTENSION_ID}.shell-extension.zip?version_tag=$VERSION_TAG"
     gnome-extensions install --force ${EXTENSION_ID}.zip
     if ! gnome-extensions list | grep --quiet ${EXTENSION_ID}; then
         busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s ${EXTENSION_ID}
     fi
     gnome-extensions enable ${EXTENSION_ID}
     rm ${EXTENSION_ID}.zip
  done
fi

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
#VS Codium
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
