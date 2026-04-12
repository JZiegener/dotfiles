#!/bin/sh
# Stage 5: Dev tools — mise + lazygit + gh-dash
set -e

echo "=== Stage 5: Dev Tools ==="

# ── mise (version manager) ──────────────────────────────
if ! command -v mise >/dev/null 2>&1; then
  echo "Installing mise..."
  curl https://mise.run | sh
  # Add to PATH for this session
  export PATH="$HOME/.local/bin:$PATH"
else
  echo "Mise already installed: $(mise --version)"
fi

# ── lazygit ─────────────────────────────────────────────
if ! command -v lazygit >/dev/null 2>&1; then
  echo "Installing lazygit..."
  if command -v go >/dev/null 2>&1; then
    go install github.com/jesseduffield/lazygit@latest
  else
    echo "Go not found. Install lazygit from:"
    echo "  https://github.com/jesseduffield/lazygit/releases"
  fi
else
  echo "Lazygit already installed: $(lazygit --version | head -1)"
fi

# ── delta (git diff pager for lazygit) ──────────────────
if ! command -v delta >/dev/null 2>&1; then
  echo "Installing git-delta..."
  if command -v cargo >/dev/null 2>&1; then
    cargo install git-delta
  else
    echo "Install delta from: https://github.com/dandavison/delta/releases"
  fi
fi

# ── gh (GitHub CLI) ─────────────────────────────────────
if ! command -v gh >/dev/null 2>&1; then
  echo "Installing GitHub CLI..."
  sudo apt-get update -qq
  sudo apt-get install -y gh
else
  echo "GitHub CLI already installed: $(gh --version | head -1)"
fi

# ── gh-dash extension ──────────────────────────────────
if command -v gh >/dev/null 2>&1; then
  if ! gh extension list 2>/dev/null | grep -q 'dlvhdr/gh-dash'; then
    echo "Installing gh-dash..."
    gh extension install dlvhdr/gh-dash
  else
    echo "gh-dash already installed"
  fi
fi

# ── Deploy configs via stow ────────────────────────────
DOTFILES_DIR="$HOME/repos/dotfiles"
if [ -d "$DOTFILES_DIR" ]; then
  cd "$DOTFILES_DIR"
  echo "Stowing configs: mise lazygit..."
  stow mise lazygit
fi

# ── Add mise to shell ──────────────────────────────────
echo ""
echo "=== Stage 5 Complete ==="
echo ""
echo "Add mise activation to your shell config:"
echo '  bash: eval "$(mise activate bash)"'
echo '  zsh:  eval "$(mise activate zsh)"'
echo '  fish: mise activate fish | source'
echo ""
echo "Key commands:"
echo "  mise install go@latest    Install a runtime"
echo "  mise use go@1.22          Set version for project"
echo "  mise current              Show active versions"
echo "  lazygit                   Open git TUI"
echo "  gh dash                   Open PR dashboard"
echo ""
echo "See docs/stage5-devtools.md for full guide."
