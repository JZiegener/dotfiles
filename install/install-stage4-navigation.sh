#!/bin/sh
# Stage 4: File navigation — television + yazi
set -e

echo "=== Stage 4: File Navigation ==="

# ── apt dependencies ────────────────────────────────────
echo "Installing apt dependencies..."
sudo apt-get update -qq
sudo apt-get install -y bat ripgrep fd-find

# bat is 'batcat' on Ubuntu, create alias
if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(which batcat)" "$HOME/.local/bin/bat"
fi

# fd is 'fdfind' on Ubuntu
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
fi

# ── Television ──────────────────────────────────────────
if ! command -v tv >/dev/null 2>&1; then
  echo "Installing television..."
  if command -v cargo >/dev/null 2>&1; then
    cargo install television
  else
    echo "Cargo not found. Install Rust first or download from:"
    echo "  https://github.com/alexpasmantier/television/releases"
  fi
else
  echo "Television already installed: $(tv --version 2>&1 || echo 'installed')"
fi

# ── Yazi ────────────────────────────────────────────────
if ! command -v yazi >/dev/null 2>&1; then
  echo "Installing yazi..."
  if command -v cargo >/dev/null 2>&1; then
    cargo install --locked yazi-fm yazi-cli
  else
    echo "Cargo not found. Install Rust first or download from:"
    echo "  https://github.com/sxyazi/yazi/releases"
  fi
else
  echo "Yazi already installed: $(yazi --version 2>&1 || echo 'installed')"
fi

# ── eza (modern ls) ────────────────────────────────────
if ! command -v eza >/dev/null 2>&1; then
  echo "Installing eza..."
  if command -v cargo >/dev/null 2>&1; then
    cargo install eza
  else
    echo "Try: sudo apt install eza (Ubuntu 24.04+)"
  fi
fi

# ── Deploy configs via stow ────────────────────────────
DOTFILES_DIR="$HOME/repos/dotfiles"
if [ -d "$DOTFILES_DIR" ]; then
  cd "$DOTFILES_DIR"
  echo "Stowing configs: television yazi..."
  stow television yazi
fi

echo ""
echo "=== Stage 4 Complete ==="
echo ""
echo "Key commands:"
echo "  Ctrl-T (in shell)  Smart autocomplete (television)"
echo "  tv                 Open television standalone"
echo "  Ctrl-S (in tv)     Cycle data sources"
echo "  yazi               Open file manager"
echo "  y                  Alias for yazi (add to your shell)"
echo ""
echo "See docs/stage4-navigation.md for full guide."
