#!/bin/sh
# Stage 1: Cross-shell foundation
# Installs kitty, tmux, TPM, starship, zoxide, atuin, fzf
set -e

echo "=== Stage 1: Cross-Shell Foundation ==="

# ── Kitty terminal emulator ─────────────────────────────
if ! command -v kitty >/dev/null 2>&1; then
  echo "Installing kitty..."
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
  # Create desktop integration
  mkdir -p ~/.local/bin
  ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty
  ln -sf ~/.local/kitty.app/bin/kitten ~/.local/bin/kitten
  # Desktop entry for application launchers
  mkdir -p ~/.local/share/applications
  cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
  sed -i "s|Icon=kitty|Icon=$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" \
    ~/.local/share/applications/kitty.desktop
  sed -i "s|Exec=kitty|Exec=$HOME/.local/kitty.app/bin/kitty|g" \
    ~/.local/share/applications/kitty.desktop
else
  echo "Kitty already installed: $(kitty --version)"
fi

# ── apt packages ─────────────────────────────────────────
echo "Installing apt packages..."
sudo apt-get update -qq
sudo apt-get install -y tmux fzf

# ── Starship prompt ─────────────────────────────────────
if ! command -v starship >/dev/null 2>&1; then
  echo "Installing starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
else
  echo "Starship already installed: $(starship --version)"
fi

# ── Zoxide ──────────────────────────────────────────────
if ! command -v zoxide >/dev/null 2>&1; then
  echo "Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
  echo "Zoxide already installed: $(zoxide --version)"
fi

# ── Atuin ───────────────────────────────────────────────
if ! command -v atuin >/dev/null 2>&1; then
  echo "Installing atuin..."
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
else
  echo "Atuin already installed: $(atuin --version)"
fi

# ── TPM (tmux plugin manager) ──────────────────────────
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  echo "TPM already installed"
fi

# ── Deploy configs via stow ────────────────────────────
DOTFILES_DIR="$HOME/repos/dotfiles"
if [ -d "$DOTFILES_DIR" ]; then
  cd "$DOTFILES_DIR"
  echo "Stowing configs: bash kitty tmux starship atuin..."
  stow bash kitty tmux starship atuin
fi

echo ""
echo "=== Stage 1 Complete ==="
echo ""
echo "Next steps:"
echo "  1. Launch kitty terminal (or open a new terminal)"
echo "  2. Source your config: source ~/.bashrc"
echo "  3. Start tmux: tmux new -s main"
echo "  3. Install tmux plugins: press Ctrl-A then I (capital I)"
echo "  4. Try zoxide: z <partial-directory-name>"
echo "  5. Try atuin: Ctrl-R to search history"
echo "  6. Run 'starship explain' to see prompt segments"
echo ""
echo "See docs/stage1-foundation.md for full walkthrough."
