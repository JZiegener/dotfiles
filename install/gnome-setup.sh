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


