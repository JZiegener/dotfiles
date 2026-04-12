# Stage 1: Cross-Shell Foundation

## What's Installed

| Tool | What it does | Config |
|------|-------------|--------|
| **kitty** | GPU-accelerated terminal emulator — fast rendering, image protocol, ligatures | `~/.config/kitty/kitty.conf` |
| **tmux** | Terminal multiplexer — multiple panes, windows, sessions | `~/.config/tmux/tmux.conf` |
| **TPM** | tmux Plugin Manager — installs/updates tmux plugins | `~/.tmux/plugins/tpm/` |
| **starship** | Cross-shell prompt — shows git branch, language versions, etc. | `~/.config/starship/starship.toml` |
| **zoxide** | Frecency-based `cd` — jump to directories by partial name | shell init (no config file) |
| **atuin** | Shell history — SQLite-backed, fuzzy search, secret filtering | `~/.config/atuin/config.toml` |
| **fzf** | Fuzzy finder — used by tmux plugins (fzf-url, sessionx) | none |

## How It All Fits Together

```
┌───────────────────────────────────────────────────────────┐
│ KITTY (terminal emulator — GPU-accelerated rendering)     │
│                                                           │
┌─────────────────────────────────────────────────────────┐
│ TMUX (always running — outermost layer)                 │
│  Prefix: Ctrl-A                                         │
│  ┌───────────────────────────────────────────────────┐  │
│  │ STATUS BAR (top, catppuccin theme)                │  │
│  │  [session]  [win1] [win2*] [win3]        [~/dir] │  │
│  └───────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────┐  │
│  │ SHELL                                             │  │
│  │                                                   │  │
│  │  STARSHIP PROMPT:  ~/repos/dotfiles main ➜        │  │
│  │                                                   │  │
│  │  z repo ............. zoxide jump                  │  │
│  │  Ctrl-R ............. atuin history search         │  │
│  │  Up arrow ........... atuin inline history         │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

## Getting Started

```bash
# Run the install script
./install/install-stage1-foundation.sh

# Or install manually:
sudo apt install tmux fzf
curl -sS https://starship.rs/install.sh | sh
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Deploy configs
cd ~/repos/dotfiles && stow bash tmux starship atuin

# Reload shell
source ~/.bashrc
```

## Kitty — Terminal Emulator

Kitty is the GPU-accelerated terminal emulator that everything else runs inside. tmux handles multiplexing (panes, windows, sessions) — Kitty just renders pixels fast.

### Key Commands

| Action | Keys |
|--------|------|
| **Copy to clipboard** | `Ctrl+Shift+C` |
| **Paste from clipboard** | `Ctrl+Shift+V` |
| **Increase font size** | `Ctrl+=` |
| **Decrease font size** | `Ctrl+-` |
| **Reset font size** | `Ctrl+0` |

### Configuration

Config at `~/.config/kitty/kitty.conf` (symlinked from `kitty/.config/kitty/kitty.conf` in the repo).

Key settings:
- **Font size:** 14pt, ligatures enabled
- **Window:** No decorations, 95% opacity, 4px padding
- **Mouse:** Auto-hide after 3s, copy-on-select to clipboard
- **Scrollback:** 10,000 lines (tmux has its own scrollback)
- **Tab bar:** Hidden — tmux handles tabs/windows
- **Theme:** Catppuccin Mocha (matches tmux and starship)
- **Terminal:** `xterm-256color` with shell integration

### Updating Kitty

Re-run the installer — it updates in place:

```bash
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
```

### Why Kitty's Tab Bar Is Disabled

Kitty has its own tabs and splits, but tmux handles all of that. Running both would mean two layers of multiplexing with conflicting keybindings. Kitty's `tab_bar_style hidden` keeps it out of the way.

Full reference: https://sw.kovidgoyal.net/kitty/conf/

## tmux — Terminal Multiplexer

Your prefix key is **Ctrl-A** (not the default Ctrl-B).

### Essential Commands

| Action | Keys | Notes |
|--------|------|-------|
| **Split vertical** | `Ctrl-A v` | New pane to the right |
| **Split horizontal** | `Ctrl-A s` | New pane below |
| **Navigate panes** | `Ctrl-A h/j/k/l` | Vi-style movement |
| **Resize panes** | `Ctrl-A ,/./-/=` | Left/Right/Down/Up (20px/7px) |
| **Zoom pane** | `Ctrl-A z` | Toggle fullscreen for current pane |
| **Close pane** | `Ctrl-A c` | Kills the pane |
| **Previous window** | `Ctrl-A H` | Capital H |
| **Next window** | `Ctrl-A L` | Capital L |
| **New window** | `Ctrl-A Ctrl-C` | Opens in $HOME |
| **Rename window** | `Ctrl-A r` | Then type name |
| **Last window** | `Ctrl-A Ctrl-A` | Toggle back |
| **Float a pane** | `Ctrl-A p` | 80% floating overlay (floax) |
| **Session picker** | `Ctrl-A o` | Fuzzy session list (sessionx) |
| **Choose session** | `Ctrl-A S` | tmux built-in session list |
| **Open URLs** | `Ctrl-A u` | fzf-url picks links from scrollback |
| **Reload config** | `Ctrl-A R` | Capital R |
| **Clear screen** | `Ctrl-A K` | Sends clear + enter |
| **Sync panes** | `Ctrl-A *` | Type in all panes simultaneously |
| **Copy mode** | `Ctrl-A [` | Vi keys to navigate, `v` to select |

### Plugin Management (TPM)

| Action | Keys |
|--------|------|
| Install plugins | `Ctrl-A I` (capital I) |
| Update plugins | `Ctrl-A U` (capital U) |
| Uninstall removed plugins | `Ctrl-A Alt-u` |

**First time:** After starting tmux, press `Ctrl-A I` to install all plugins. You'll see a progress indicator.

### Installed Plugins

| Plugin | What it does |
|--------|-------------|
| **tmux-sensible** | Sensible defaults (utf-8, larger history, etc.) |
| **tmux-yank** | Copy to system clipboard from copy mode |
| **tmux-resurrect** | Save/restore tmux sessions across restarts |
| **tmux-continuum** | Auto-save sessions every 15 minutes, auto-restore on tmux start |
| **tmux-fzf** | Fuzzy finder for sessions, windows, panes |
| **tmux-fzf-url** | Extract and open URLs from scrollback |
| **catppuccin/tmux** | Catppuccin Mocha color theme |
| **tmux-sessionx** | Enhanced session picker with zoxide integration |
| **tmux-floax** | Floating panes — overlay that doesn't disrupt layout |

### Session Workflow

Sessions persist across disconnects. Continuum auto-saves/restores.

```bash
# Create a named session
tmux new -s myproject

# Detach (session keeps running)
Ctrl-A d

# List sessions
tmux ls

# Attach to existing session
tmux attach -t myproject

# Inside tmux: switch sessions
Ctrl-A o    # sessionx picker (fuzzy search)
Ctrl-A S    # built-in session list
```

## Starship — Prompt

Starship replaces the custom `__ps1` bash prompt. It shows:

- **Left:** Directory + character indicator (green `➜` on success)
- **Right:** Git branch, language versions (Go, Node, etc.), AWS profile, K8s context

### Key Commands

| Action | Command |
|--------|---------|
| See what each segment shows | `starship explain` |
| Print current prompt config | `starship print-config` |
| Debug prompt issues | `starship bug-report` |
| Test a module | `starship module git_branch` |

### Customizing

Edit `~/.config/starship/starship.toml` (symlinked from `starship/.config/starship/starship.toml` in the repo).

Full module reference: https://starship.rs/config/

## Zoxide — Smart Directory Jumping

Zoxide learns which directories you visit frequently and lets you jump to them with partial names.

### Key Commands

| Action | Command | Example |
|--------|---------|---------|
| Jump to directory | `z <partial>` | `z dot` → `~/repos/dotfiles` |
| Jump interactively | `zi` | Opens fzf picker |
| Add a directory | `zoxide add <path>` | Manually add to database |
| List known dirs | `zoxide query -l` | See what zoxide knows |
| Remove a dir | `zoxide remove <path>` | Remove from database |

### How It Learns

Every time you `cd` or `z` somewhere, zoxide records it. Directories you visit often and recently get higher scores (frecency = frequency + recency).

```bash
# First time: cd normally
cd ~/repos/dotfiles

# Next time: just use z
z dot          # matches "dotfiles"
z repo dot     # matches "repos/dotfiles" (multiple keywords)
```

## Atuin — Shell History

Atuin replaces the default `Ctrl-R` history search with a fuzzy, SQLite-backed interface.

### Key Commands

| Action | Keys/Command |
|--------|-------------|
| **Search history** | `Ctrl-R` |
| Navigate results | `Up/Down` arrows |
| Execute selected | `Enter` |
| Edit before running | `Tab` |
| Filter by directory | Toggle filter mode in the UI |
| View stats | `atuin stats` |
| History list | `atuin history list` |

### Configuration Highlights

Your config (`~/.config/atuin/config.toml`):
- **Compact UI** — takes less screen space
- **Fuzzy search** — matches anywhere in the command
- **Up arrow filters by current directory** — only shows commands run in this dir
- **Secret filtering** — auto-excludes AWS keys, tokens, etc.
- **Workspace-aware** — filters by git repo when in one
- **Enter executes immediately** — press Tab to edit first

### Syncing History (Optional)

Atuin can sync history across machines. To set up:

```bash
atuin register -u <username> -e <email>
atuin login -u <username>
atuin sync
```

## Troubleshooting

**Kitty not found after install:**
The binary installs to `~/.local/kitty.app/bin/kitty` with a symlink at `~/.local/bin/kitty`. Make sure `~/.local/bin` is in your PATH.

**Starship prompt not showing:**
Check `starship` is in PATH: `which starship`. Reload: `source ~/.bashrc`.

**tmux plugins not loading:**
Press `Ctrl-A I` to install. Check TPM: `ls ~/.tmux/plugins/`.

**Zoxide not jumping:**
It needs to learn your directories first. Use `cd` normally for a while, then `z` will start working.

**Atuin Ctrl-R not working:**
Check `atuin` is in PATH: `which atuin`. Restart shell.

**Old prompt still showing:**
The `__ps1` function is still defined but `PROMPT_COMMAND` is commented out. If starship isn't installed, uncomment `PROMPT_COMMAND="__ps1"` in `.bashrc` to restore the old prompt.

## Reference

- Kitty: `kitty --help`, https://sw.kovidgoyal.net/kitty/conf/
- tmux: `man tmux`, `Ctrl-A ?` for keybinding list
- Starship: `starship explain`, https://starship.rs/config/
- Zoxide: `z --help`, https://github.com/ajeetdsouza/zoxide
- Atuin: `atuin --help`, https://docs.atuin.sh
- TPM: https://github.com/tmux-plugins/tpm
