#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# setup-remote-streaming.sh — Scripts to set up 
#
# Written to work with debian 12 (trixie)
# -----------------------------------------------------------------------------

# ----------------------------------------------------------------------
#  Safety rails
# ----------------------------------------------------------------------
set -euo pipefail
# -e  : exit immediately on non-zero status
# -u  : treat unset variables as errors
# -o pipefail : fail a pipeline if any component command fails

# setup backports sources
if [ ! -f /etc/apt/sources.list.d/debian-backports.sources ]; then
    cat << 'EOF' > /etc/apt/sources.list.d/debian-backports.sources
Types: deb deb-src
URIs: http://deb.debian.org/debian
Suites: trixie-backports
Components: main
Enabled: yes
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
EOF
fi

apt-get update
# Update Kernal
apt-get install -t trixie-backports linux-image-amd64

# Install desktop and sound
if ! dpkg -l | grep -q kde-plasma-desktop; then
    apt-get install kde-plasma-desktop 
    adduser $USER audio video render
fi

# Install Flatpak
if ! command -v flatpak &> /dev/null; then
    apt-get install flatpak
fi

if ! flatpak remote-list | grep -q flathub; then
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
fi

flatpak update --appstream

# Browser
if ! flatpak list | grep -q firefox; then
    flatpak install flathub firefox -y
    mkdir -p /var/lib/flatpak/extension/org.mozilla.firefox.systemconfig/x86_64/stable/policies
    cp ~/repos/dotfiles/install/config/firefox-policies.json /var/lib/flatpak/extension/org.mozilla.firefox.systemconfig/x86_64/stable/policies/policies.json
    cat << 'EOF' > /var/lib/flatpak/extension/org.mozilla.firefox.systemconfig/x86_64/stable/policies/policies.json
{
  "policies": {
    "Extensions": {
      "Install": [
        "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi",
        "https://addons.mozilla.org/firefox/downloads/latest/lastpass-password-manager/latest.xpi",
        "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi"
      ]
    },
    "ExtensionUpdate": true,
    "DisableTelemetry": true,
    "DisableFirefoxStudies": true,
    "EnableTrackingProtection": {
      "Value": true,
      "Locked": false,
      "Cryptomining": true,
      "Fingerprinting": true,
      "EmailTracking": true,
      "Exceptions": []
    },
    "Preferences": {
      "media.eme.enabled": {
        "Value": true,
        "Status": "locked"
      },
      "media.gmp-widevinecdm.enabled": {
        "Value": true,
        "Status": "locked"
      }
    },
     "PictureInPicture": {
      "Enabled": false,
      "Locked": true 
    },
    "GenerativeAI": {
      "Enabled": false,
      "Chatbot": false,
      "LinkPreviews":  false,
      "TabGroups": false,
      "Locked": false
    }
  }
}
EOF
fi


# Steam
if ! flatpak list | grep -q steam; then
    flatpak install flathub steam -y
fi
