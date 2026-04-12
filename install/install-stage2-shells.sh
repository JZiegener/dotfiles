#!/bin/sh
# Stage 2: Shell evaluation sandbox
# Installs zsh, nushell, fish for side-by-side comparison
set -e

echo "=== Stage 2: Shell Evaluation Sandbox ==="

# ── Zsh ──────────────────────────────────────────────────
echo "Installing zsh..."
sudo apt-get update -qq
sudo apt-get install -y zsh zsh-autosuggestions zsh-syntax-highlighting

# ── Fish ─────────────────────────────────────────────────
echo "Installing fish..."
sudo apt-get install -y fish

# ── Nushell ──────────────────────────────────────────────
if ! command -v nu >/dev/null 2>&1; then
  echo "Installing nushell..."
  if command -v cargo >/dev/null 2>&1; then
    cargo install nu
  else
    echo "Cargo not found. Install Rust first: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    echo "Or download nushell binary from: https://github.com/nushell/nushell/releases"
  fi
else
  echo "Nushell already installed: $(nu --version)"
fi

# ── Deploy configs via stow ────────────────────────────
DOTFILES_DIR="$HOME/repos/dotfiles"
if [ -d "$DOTFILES_DIR" ]; then
  cd "$DOTFILES_DIR"
  echo "Stowing configs: zsh nushell fish..."
  stow zsh nushell fish
fi

echo ""
echo "=== Stage 2 Complete ==="
echo ""
echo "Try each shell in a tmux window:"
echo "  tmux new-window 'zsh'"
echo "  tmux new-window 'nu'"
echo "  tmux new-window 'fish'"
echo ""
echo "All shells share the same starship prompt, zoxide, and atuin."
echo "DO NOT change your login shell yet — evaluate first."
echo ""
echo "See docs/stage2-shells.md for comparison guide."
