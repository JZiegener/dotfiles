#!/bin/sh

sudo apt-get install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak update --appstream

# Browser
flatpak install flathub firefox -y
sudo mkdir -p /var/lib/flatpak/extension/org.mozilla.firefox.systemconfig/x86_64/stable/policies
sudo cp ~/repos/dotfiles/install/config/firefox-policies.json /var/lib/flatpak/extension/org.mozilla.firefox.systemconfig/x86_64/stable/policies/policies.json

#VS Codium
flatpak install flathub vscodium -y
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension EditorConfig.EditorConfig
code --install-extension golang.go
code --install-extension esbenp.prettier-vscode

flatpak install flathub obsidian -y
flatpak install flathub steam -y

#media
flatpak install flathub spotify -y

# Communication
flatpak install flathub discord -y