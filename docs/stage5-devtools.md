# Stage 5: Dev Tools

## What's Installed

| Tool | What it does |
|------|-------------|
| **mise** | Runtime version manager — replaces manual Go/Node/Python installs |
| **lazygit** | Terminal UI for git — stage, commit, push, branch, merge |
| **delta** | Git diff pager with syntax highlighting (used by lazygit) |
| **gh-dash** | GitHub dashboard — PRs, issues, notifications in the terminal |

## mise — Version Manager

mise replaces your hardcoded Go environment variables and manual install scripts.

### How It Works

```
~/.config/mise/config.toml     ← global defaults
~/repos/myproject/.mise.toml   ← per-project versions (committed to git)
```

When you `cd` into a project, mise automatically activates the right versions.

### Setup

Add to your shell config (after Stage 1 tools):

```bash
# bash
eval "$(mise activate bash)"

# zsh
eval "$(mise activate zsh)"

# fish
mise activate fish | source

# nushell (in env.nu)
mkdir ~/.cache/mise
^mise activate nu | save -f ~/.cache/mise/init.nu
# then in config.nu: use ~/.cache/mise/init.nu
```

### Key Commands

| Action | Command |
|--------|---------|
| Install a runtime | `mise install go@latest` |
| Set global version | `mise use -g go@latest` |
| Set project version | `mise use go@1.22` (creates .mise.toml) |
| Show active versions | `mise current` |
| List installed | `mise ls` |
| List available | `mise ls-remote go` |
| Diagnostics | `mise doctor` |
| Self-update | `mise self-update` |

### Per-Project Example

```bash
cd ~/repos/myproject
mise use go@1.22 node@20
# Creates .mise.toml:
# [tools]
# go = "1.22"
# node = "20"
```

Now anyone with mise who clones the repo gets the right versions automatically.

### Migrating From Current Go Setup

Your current `.bashrc` has:
```bash
export GOPATH="/home/$USER"
export GOBIN="/usr/local/go/bin"
export GOPROXY=direct
export CGO_ENABLED=0
```

With mise:
- `GOPATH` and `GOBIN` are managed by mise
- `GOPROXY` and `CGO_ENABLED` stay in `.bashrc` (they're Go behavior flags, not version management)
- Remove the `install-golang.sh` script — mise handles it

## lazygit — Git TUI

### Opening

```bash
lazygit       # from any git repo
# or alias:
lg            # add to shell: alias lg='lazygit'
```

### Layout

```
┌──────────────────────┬──────────────────────────────┐
│ Status               │ Main panel                   │
│ ──────               │                              │
│ Files                │ Shows diff, log, or content  │
│ ──────               │ of whatever is selected      │
│ Branches             │ in the side panel             │
│ ──────               │                              │
│ Commits              │                              │
│ ──────               │                              │
│ Stash                │                              │
└──────────────────────┴──────────────────────────────┘
```

### Key Commands

Navigate between panels with `Tab` or number keys (`1`-`5`).

**Files panel (1):**

| Keys | Action |
|------|--------|
| `Space` | Stage/unstage file |
| `a` | Stage all |
| `c` | Commit staged changes |
| `Enter` | View file diff (line-by-line staging) |
| `d` | Discard changes |
| `e` | Edit file in `$EDITOR` |

**Branches panel (3):**

| Keys | Action |
|------|--------|
| `Space` | Checkout branch |
| `n` | New branch |
| `d` | Delete branch |
| `M` | Merge into current |
| `r` | Rebase onto current |

**Commits panel (4):**

| Keys | Action |
|------|--------|
| `Enter` | View commit |
| `s` | Squash into parent |
| `r` | Reword commit message |
| `g` | Reset to commit |

**Global:**

| Keys | Action |
|------|--------|
| `P` | Push |
| `p` | Pull |
| `?` | Show all keybindings |
| `q` | Quit |
| `+` | Open diff view |
| `/` | Search |

### Recommended Workflow

```
1. Open lazygit in a tmux pane alongside your editor
2. Write code in nvim
3. Switch to lazygit pane (Ctrl-A l)
4. Space to stage files
5. c to commit
6. P to push
7. Switch back to editor
```

## gh-dash — GitHub Dashboard

### Opening

```bash
gh dash
```

Shows PRs and issues across your repos. Requires `gh auth login` first.

### Navigation

| Keys | Action |
|------|--------|
| `j/k` | Navigate |
| `Enter` | Open in browser |
| `d` | View diff |
| `c` | View comments |
| `/` | Search |
| `q` | Quit |

## Useful Aliases

Add to your shell:
```bash
alias lg='lazygit'
alias gd='gh dash'
```

## Reference

- mise: `mise --help`, `mise doctor`, https://mise.jdx.dev
- lazygit: `?` in TUI, https://github.com/jesseduffield/lazygit
- delta: https://github.com/dandavison/delta
- gh-dash: https://github.com/dlvhdr/gh-dash
