#!/bin/sh
# Stage 0: Install GNU Stow and deploy base configs
set -e

echo "=== Stage 0: GNU Stow Setup ==="

# Install stow
if ! command -v stow >/dev/null 2>&1; then
  echo "Installing GNU Stow..."
  sudo apt-get update -qq
  sudo apt-get install -y stow
else
  echo "GNU Stow already installed: $(stow --version 2>&1 | head -1)"
fi

# Deploy base configs
DOTFILES_DIR="$HOME/repos/dotfiles"
if [ -d "$DOTFILES_DIR" ]; then
  cd "$DOTFILES_DIR"
  echo "Deploying base configs (bash, tmux, vim)..."
  stow bash tmux vim
  echo "Done. Configs symlinked to home directory."
else
  echo "Error: dotfiles repo not found at $DOTFILES_DIR"
  exit 1
fi

echo ""
echo "=== Stage 0 Complete ==="
echo "Your configs are now managed by stow."
echo "To add/remove a config package: stow <package> / stow -D <package>"
echo "See docs/stage0-stow.md for details."
