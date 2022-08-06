#!/bin/bash
# A script to perform incremental backups using rsync

set -o errexit
set -o nounset
set -o pipefail

readonly SOURCE_DIR="${HOME}"
readonly BACKUP_DIR="/mnt/pve/backup/${HOSTNAME}"
readonly DATETIME="$(date '+%Y-%m-%d_%H:%M:%S')"
readonly BACKUP_PATH="${BACKUP_DIR}/${DATETIME}"
readonly LATEST_LINK="${BACKUP_DIR}/latest"

mkdir -p "${BACKUP_DIR}"

rsync -av --delete \
  "${SOURCE_DIR}/" \
  --link-dest "${LATEST_LINK}" \
  --exclude=".cache" \
  --exclude=".steam" \
  --exclude=".java" \
  --exclude=".cinnamon" \
  --exclude=".paradoxlauncher" \
  --exclude=".config/Code/Cache"\
  --exclude=".config/Code/CachedData"\
  --exclude=".config/Code/Service Worker"\
  --exclude=".config/Code/logs"\
  --exclude=".config/Code/Crashpad"\
  --exclude=".config/chromium"\
  --exclude=".config/google-chrome"\
  --exclude=".config/discord"\
  --exclude=".config/unity3d" \
  --exclude=".config/spotify" \
  --exclude=".local/pipx" \
  --exclude=".local/lib/python3.8/" \
  --exclude=".local/share/Colossal Order"\
  --exclude=".local/share/Aspyr Media"\
  --exclude=".local/share/aspyr-media"\
  --exclude=".local/share/Paradox Interactive"\
  --exclude=".cargo"\
  --exclude=".kube/cache"\
  --exclude=".local/share/cinnamon"\
  --exclude=".local/share/feral-interactive"\
  --exclude=".local/share/lutris"\
  --exclude=".minecraft"\
  --exclude=".mozilla/firefox"\
  --exclude=".local/share/icons"\
  --exclude=".local/share/rancher-desktop"\
  --exclude=".themes"\
  --exclude=".thunderbird"\
  --exclude=".vim"\
  --exclude=".vscode"\
  --exclude=".wine"\
  --exclude="Games"\
  --exclude="go/pkg"\
  --exclude="pkg/mod"\
  "${BACKUP_PATH}"

rm -rf "${LATEST_LINK}"
ln -s "${BACKUP_PATH}" "${LATEST_LINK}"
