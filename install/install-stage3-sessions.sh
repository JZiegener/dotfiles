#!/bin/sh
# Stage 3: Session management — sesh + worktrunk
set -e

echo "=== Stage 3: Session Management ==="

# ── sesh ────────────────────────────────────────────────
if ! command -v sesh >/dev/null 2>&1; then
  echo "Installing sesh..."
  if command -v go >/dev/null 2>&1; then
    go install github.com/joshmedeski/sesh@latest
  else
    echo "Go not found. Install Go first, or download sesh binary from:"
    echo "  https://github.com/joshmedeski/sesh/releases"
  fi
else
  echo "Sesh already installed: $(sesh --version 2>&1 || echo 'installed')"
fi

# ── worktrunk ──────────────────────────────────────────
if ! command -v wt >/dev/null 2>&1; then
  echo "Installing worktrunk..."
  if command -v brew >/dev/null 2>&1; then
    brew install worktrunk
  elif command -v cargo >/dev/null 2>&1; then
    cargo install worktrunk
  else
    echo "Install worktrunk manually from:"
    echo "  https://github.com/max-sixty/worktrunk/releases"
  fi
else
  echo "Worktrunk already installed: $(wt --version 2>&1 || echo 'installed')"
fi

# ── fd-find ─────────────────────────────────────────────
if ! command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  echo "Installing fd-find..."
  sudo apt-get update -qq
  sudo apt-get install -y fd-find
fi

# Create fd alias on Ubuntu (binary is fdfind)
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
  echo "Created fd alias: ~/.local/bin/fd -> fdfind"
fi

# ── Deploy config via stow ─────────────────────────────
DOTFILES_DIR="$HOME/repos/dotfiles"
if [ -d "$DOTFILES_DIR" ]; then
  cd "$DOTFILES_DIR"
  echo "Stowing sesh config..."
  stow sesh
fi

echo ""
echo "=== Stage 3 Complete ==="
echo ""
echo "Key commands:"
echo "  sesh connect <name>         Create/attach tmux session"
echo "  sesh list                   List all sessions + zoxide dirs"
echo "  Ctrl-A o                    Session picker in tmux (sessionx)"
echo "  wt switch --create <branch> Create worktree + switch to it"
echo "  wt list                     List worktrees"
echo "  wt merge                    Merge worktree back"
echo ""
echo "See docs/stage3-sessions.md for workflow guide."
