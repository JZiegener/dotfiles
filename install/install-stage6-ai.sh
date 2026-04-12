#!/bin/sh
# Stage 6: AI tools — opencode
set -e

echo "=== Stage 6: AI Tools ==="

# ── opencode ────────────────────────────────────────────
if ! command -v opencode >/dev/null 2>&1; then
  echo "Installing opencode..."
  if command -v go >/dev/null 2>&1; then
    go install github.com/opencode-ai/opencode@latest
  else
    echo "Go not found. Install opencode from:"
    echo "  https://github.com/opencode-ai/opencode/releases"
  fi
else
  echo "Opencode already installed"
fi

# ── Deploy config via stow ─────────────────────────────
DOTFILES_DIR="$HOME/repos/dotfiles"
if [ -d "$DOTFILES_DIR" ]; then
  cd "$DOTFILES_DIR"
  echo "Stowing opencode config..."
  stow opencode
fi

echo ""
echo "=== Stage 6 Complete ==="
echo ""
echo "Usage:"
echo "  opencode                  Launch TUI"
echo "  opencode --prompt 'msg'   Run with a prompt"
echo ""
echo "In tmux: Ctrl-A p to open a float, then run opencode"
echo ""
echo "See docs/stage6-ai.md for usage guide."
