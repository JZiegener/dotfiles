#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# create-user.sh — Interactive helper to create a non-root sudo user,
#                  harden SSH, and migrate root SSH keys.
#
# Works on modern Ubuntu (20.04/22.04) but should be portable to most
# systemd-based Linux distributions that ship OpenSSH and use /etc/ssh/sshd_config.
# -----------------------------------------------------------------------------

# ----------------------------------------------------------------------
#  Safety rails
# ----------------------------------------------------------------------
set -euo pipefail
# -e  : exit immediately on non-zero status
# -u  : treat unset variables as errors
# -o pipefail : fail a pipeline if any component command fails

apt-get update -qq


ssh-copy-id root@

# ----------------------------------------------------------------------
#  4. Create the user with a bash login shell and add to sudoers
# ----------------------------------------------------------------------
default_shell="/bin/bash"
useradd --create-home --shell "$default_shell" "$username"

echo "${username}:${password1}" | chpasswd
usermod -aG sudo "$username"
usermod -aG docker "$username"

wget https://raw.githubusercontent.com/JZiegener/dotfiles/refs/heads/main/.bashrc | cp ~/.bashrc
cp ~/.bashrc /home/"$username"/.bashrc

# ----------------------------------------------------------------------
#  5. Prepare the user’s ~/.ssh directory and copy root’s keys
# ----------------------------------------------------------------------
mkdir -p /home/"$username"/.ssh
chmod 700 /home/"$username"/.ssh

chmod 600 /home/"$username"/.ssh/authorized_keys
chown -R "$username":"$username" /home/"$username"/.ssh

# ----------------------------------------------------------------------
#  6. Harden SSH daemon configuration
# ----------------------------------------------------------------------
SSHCFG='/etc/ssh/sshd_config'                 # main sshd config
CLOUDINIT='/etc/ssh/sshd_config.d/50-cloud-init.conf' # cloud-init drop-in

patch_line() {
  # Replace or append a key/value pair in sshd_config.
  # Usage: patch_line <Directive> <Value>
  local key=$1
  local value=$2

  # If the directive exists (commented or not), replace the line;
  # otherwise append it at the end of the file.
  if grep -qiE "^\s*#?\s*${key}\s+" "$SSHCFG"; then
    sed -Ei "s|^\s*#?\s*${key}\s+.*|${key} ${value}|I" "$SSHCFG"
  else
    echo "${key} ${value}" >> "$SSHCFG"
  fi
}

# Disable password auth & root login; disable PAM to avoid bypass
patch_line "PasswordAuthentication" "no"
patch_line "PermitRootLogin"        "no"
patch_line "UsePAM"                 "no"

# Remove cloud-init override file (if present) so it can’t re-enable passwords
if [[ -f $CLOUDINIT ]]; then
    rm -f "$CLOUDINIT"
fi

# ------------------------------
# 7. Install utilities
# ------------------------------

sudo apt-get install git
git config --global user.email "JZiegener@gmail.com"
git config --global user.name "Jeff Ziegener"
git config --global core.editor "vim"

#ssh-keygen -t ed25519 -C "JZiegener@gmail.com" -f ~/.ssh/id_ed25519

mkdir /home/"$username"/repos
cd /home/"$username"/repos
git clone https://github.com/JZiegener/dotfiles.git

sudo apt-get install vim
cp ~/repos/dotfiles/vim/.vimrc ~/.vimrc

sudo apt-get install tmux
cp ~/repos/dotfiles/tmux/tmux.conf ~

sudo apt-get install htop
sudo apt-get install curl
sudo apt-get install net-tools
sudo apt-get install lm-sensors
sudo apt-get install htop
sudo apt-get install powertop

# ----------------------------------------------------------------------
#  8. Validate and reload sshd
# ----------------------------------------------------------------------
/usr/sbin/sshd -t          # syntax check; exits non-zero if invalid
systemctl restart ssh      # graceful restart (Ubuntu service name)

echo "✅ User $username created and SSH hardened successfully."
echo "Log off and then ssh back into the server as $username."
