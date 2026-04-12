#!/bin/sh
# Deploy dotfiles via GNU Stow
# Usage: ./setup.sh [package ...]
# If no packages specified, deploys the minimum viable set (bash, tmux, vim)

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES_DIR"

if ! command -v stow >/dev/null 2>&1; then
  echo "GNU Stow is not installed. Run: sudo apt install stow"
  exit 1
fi

# Default packages if none specified
if [ $# -eq 0 ]; then
  PACKAGES="bash tmux vim"
else
  PACKAGES="$*"
fi

for pkg in $PACKAGES; do
  if [ -d "$pkg" ]; then
    echo "Stowing $pkg..."
    stow "$pkg"
  else
    echo "Warning: package '$pkg' not found, skipping"
  fi
done

echo "Done. Stowed: $PACKAGES"
