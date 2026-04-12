#!/bin/sh
# Stage 2.5: Neovim + LazyVim
# Neovim is the $EDITOR that later tools integrate with
set -e

echo "=== Stage 2.5: Neovim + LazyVim ==="

# ── Neovim ──────────────────────────────────────────────
if ! command -v nvim >/dev/null 2>&1; then
  echo "Installing neovim..."
  # Try apt first (may be older version)
  sudo apt-get update -qq
  sudo apt-get install -y neovim

  # For latest version, use AppImage instead:
  # curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  # chmod u+x nvim.appimage
  # sudo mv nvim.appimage /usr/local/bin/nvim
else
  echo "Neovim already installed: $(nvim --version | head -1)"
fi

# ── Dependencies ────────────────────────────────────────
echo "Installing neovim dependencies..."
sudo apt-get install -y gcc make ripgrep fd-find nodejs npm

# fd is 'fdfind' on Ubuntu, create alias
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  if [ -d "$HOME/.local/bin" ]; then
    ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
  fi
fi

# ── Deploy config via stow ─────────────────────────────
DOTFILES_DIR="$HOME/repos/dotfiles"
if [ -d "$DOTFILES_DIR" ]; then
  cd "$DOTFILES_DIR"
  echo "Stowing nvim config..."
  stow nvim
fi

echo ""
echo "=== Stage 2.5 Complete ==="
echo ""
echo "Next steps:"
echo "  1. Run 'nvim' — LazyVim will auto-install on first launch"
echo "  2. Wait for plugins to install (watch the status bar)"
echo "  3. Run ':checkhealth' to verify everything is working"
echo "  4. Update EDITOR in your shell config: export EDITOR=nvim"
echo ""
echo "See docs/stage2.5-neovim.md for keybindings and workflow."
