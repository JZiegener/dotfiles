# Stage 4: File Navigation

## What's Installed

| Tool | What it does |
|------|-------------|
| **television** | Fuzzy picker with "cables" — data sources for files, git, docker, sessions, etc. |
| **yazi** | Terminal file manager with preview — three-pane, vi-style navigation |
| **bat** | `cat` with syntax highlighting (used by previews) |
| **eza** | Modern `ls` replacement with icons and git integration |
| **ripgrep** | Fast text search (used by television and neovim) |
| **fd** | Fast file finder (used by television, yazi, neovim) |

## Television — Universal Fuzzy Picker

### Shell Integration

Television integrates into your shell with two keybindings:

| Keys | What it does |
|------|-------------|
| `Ctrl-T` | **Smart autocomplete** — context-aware picker based on what you're typing |
| `Ctrl-R` | **Command history** — search through shell history |

Smart autocomplete examples:
```bash
git checkout Ctrl-T    # → shows git branches
cd Ctrl-T              # → shows directories
vim Ctrl-T             # → shows files
docker run Ctrl-T      # → shows docker images
ssh Ctrl-T             # → shows SSH hosts from config
```

### Standalone Mode

Run `tv` to open television with the files channel. Navigate:

| Keys | Action |
|------|--------|
| Type | Filter results |
| `Up/Down` | Navigate |
| `Enter` | Select |
| `Tab` | Multi-select |
| `Ctrl-S` | Cycle data sources (files → dirs → git → docker → ...) |
| `Ctrl-R` | Remote control — pick a channel from a list |
| `Ctrl-X` | Action picker — see available actions for current channel |
| `Ctrl-Y` | Copy selection to clipboard |
| `Ctrl-O` | Toggle preview |
| `Ctrl-F` | Cycle preview modes |
| `Ctrl-D/U` | Scroll preview half-page down/up |
| `F9` | Toggle help |
| `Esc` | Quit |

### Cables (Data Sources)

Cables are TOML files that define where television gets its data. Installed cables:

| Cable | What it lists | Smart trigger commands |
|-------|--------------|----------------------|
| **files** | Files in current dir | `cat`, `vim`, `cp`, `mv`, `rm` |
| **dirs** | Directories | `cd`, `ls`, `z` |
| **git-branch** | Git branches | `git checkout`, `git merge`, `git rebase` |
| **git-log** | Commit history | `git log`, `git show` |
| **git-diff** | Changed files | `git add`, `git restore` |
| **git-worktrees** | Git worktrees | — |
| **git-repos** | Git repos in ~ | `nvim`, `code` |
| **sesh** | tmux sessions + zoxide + config paths | — |
| **tmux-sessions** | Running tmux sessions | — |
| **tmux-windows** | Tmux windows | — |
| **docker-images** | Docker images | `docker run` |
| **docker-containers** | Running containers | — |
| **ssh-hosts** | SSH config hosts | — |
| **procs** | Running processes | — |
| **man-pages** | Man pages | — |
| **make-targets** | Makefile targets | — |
| **env** | Environment variables | `export`, `unset` |
| **alias** | Shell aliases | `alias`, `unalias` |

### Adding Custom Cables

Create a TOML file in `~/.config/television/cable/`:

```toml
[metadata]
name = "my-source"
description = "My custom data source"

[source]
command = "some-command that lists things"

[preview]
command = "some-command to preview '{}'"

[keybindings]
enter = "actions:open"

[actions.open]
command = "do-something-with '{}'"
mode = "execute"
```

## yazi — Terminal File Manager

### Layout

```
┌──────────┬────────────────────┬─────────────────┐
│ Parent   │ Current directory  │ Preview          │
│ dir      │                    │                  │
│          │ > file.go          │ package main     │
│ ..       │   handler.go       │                  │
│ src/     │   main.go          │ import "fmt"     │
│ docs/    │   go.mod           │                  │
│          │   README.md        │ func main() {    │
└──────────┴────────────────────┴─────────────────┘
```

### Navigation

| Keys | Action |
|------|--------|
| `h` | Go to parent directory |
| `l` or `Enter` | Open file/enter directory |
| `j/k` | Move down/up |
| `gg` | Go to first item |
| `G` | Go to last item |
| `~` | Go to home directory |

### Actions

| Keys | Action |
|------|--------|
| `e` or `Enter` | Open in `$EDITOR` |
| `o` | Open with system default |
| `y` | Yank (copy) file path |
| `d` | Delete file |
| `r` | Rename |
| `Space` | Toggle selection |
| `V` | Select all in visual mode |
| `.` | Toggle hidden files |
| `/` | Search |
| `q` | Quit |
| `?` | Help |
| `s` | Shell — drop to shell in current dir |

### Using with tmux floax

A great pattern: open yazi in a floating pane:
```
Ctrl-A p       # open float
yazi           # browse files
# select file → opens in nvim
q              # quit yazi
Ctrl-A p       # close float
```

## Useful Aliases

Add to your shell config:
```bash
alias y='yazi'
alias lt='eza --tree --level=2 --long --icons --git'
alias ll='eza -l --icons --git'
alias la='eza -la --icons --git'
```

## Reference

- Television: `tv --help`, `F9` in TUI, https://github.com/alexpasmantier/television
- Yazi: `yazi --help`, `?` in TUI, https://yazi-rs.github.io/docs/quick-start
- bat: `bat --help`, https://github.com/sharkdp/bat
- eza: `eza --help`, https://github.com/eza-community/eza
- ripgrep: `rg --help`, https://github.com/BurntSushi/ripgrep
