# Stage 6: AI Tools

## What's Installed

| Tool | What it does |
|------|-------------|
| **opencode** | TUI-based AI coding assistant (alternative to Claude Code) |

## opencode

opencode is a terminal-based AI coding assistant with a TUI interface.

### Getting Started

```bash
# Launch in a project directory
cd ~/repos/myproject
opencode

# Or with a prompt
opencode --prompt "explain the main function"
```

### Recommended tmux Workflow

Use opencode in a tmux float or split alongside your editor:

```
Option 1: Floating pane
  Ctrl-A p    → opens float
  opencode    → start AI session
  Ctrl-A p    → close float when done

Option 2: Side-by-side
  Ctrl-A v         → split vertical
  opencode         → in right pane
  Ctrl-A h         → switch to editor pane
```

### Configuration

Config at `~/.config/opencode/opencode.json`. Set your preferred model and API key:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "your-preferred-model",
  "autoupdate": true
}
```

API keys are set via environment variables (add to your shell config):
```bash
export ANTHROPIC_API_KEY="your-key"
# or
export OPENAI_API_KEY="your-key"
```

### vs Claude Code

You already have Claude Code. opencode is an alternative with:
- TUI interface (runs in terminal, no browser)
- Neovim integration (via plugin, if desired)
- Custom agents and commands

Use whichever fits your workflow better, or both.

## Reference

- opencode: `opencode --help`, https://opencode.ai
