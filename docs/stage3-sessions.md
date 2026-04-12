# Stage 3: Session Management

## What's Installed

| Tool | What it does |
|------|-------------|
| **sesh** | Creates/switches tmux sessions from directories and zoxide results |
| **worktrunk** | Git worktree manager — simple CLI for parallel branch workflows |
| **fd** | Fast file finder (used by sesh for directory scanning) |

## How sesh + tmux + zoxide Work Together

```
                    ┌─────────────────────┐
                    │       sesh          │
                    │  "connect dotfiles" │
                    └─────────┬───────────┘
                              │
              ┌───────────────┼───────────────┐
              v               v               v
        tmux sessions    zoxide dirs     config paths
        (running)        (frecency)      (sesh.toml)
              │               │               │
              └───────┬───────┘───────────────┘
                      v
            tmux session created/attached
            working dir = selected path
```

When you run `sesh connect <name>`:
1. Checks if a tmux session with that name exists → attaches
2. If it's a path → creates a session named after the directory → attaches
3. Sets the working directory to the selected path

## Key Commands

### sesh

| Action | Command |
|--------|---------|
| List all sources | `sesh list` |
| List tmux sessions only | `sesh list -t` |
| List zoxide dirs only | `sesh list -z` |
| List config paths only | `sesh list -c` |
| Connect to session/dir | `sesh connect <name-or-path>` |
| Preview a session | `sesh preview <name>` |

### tmux Integration

From inside tmux:
- `Ctrl-A o` — opens **sessionx** picker (fuzzy search across all sesh sources)
- `Ctrl-A S` — built-in tmux session chooser (simpler)

In the sessionx picker:
- Type to fuzzy search
- `Enter` — connect to selection
- `Ctrl-d` — kill selected session
- `Ctrl-y` — open zoxide result in new window

### Workflow Example

```bash
# Start your day — connect to a project
sesh connect ~/repos/myproject

# In tmux, switch to another project
Ctrl-A o    # opens picker
# type "dot" → selects dotfiles → Enter

# Back in myproject
Ctrl-A o    # type "myp" → Enter
```

## Worktrunk — Git Worktree Manager

Worktrunk (`wt`) wraps git worktrees with a simpler interface. Instead of managing paths manually, you just work with branch names.

### Why Worktrees

Without worktrees:
```bash
# Working on feature-x, need to review a PR
git stash                    # save current work
git checkout pr-branch       # switch branches
# review...
git checkout feature-x       # switch back
git stash pop                # restore work
```

With worktrees:
```bash
# Each branch is its own directory — no stashing, no switching
wt switch feature-x          # cd into feature-x worktree
wt switch pr-review          # cd into pr-review worktree
# Both exist simultaneously
```

### Worktrunk Commands

| Action | Command |
|--------|---------|
| Create + switch to worktree | `wt switch --create feature-x` |
| Switch to existing worktree | `wt switch feature-x` |
| List all worktrees | `wt list` |
| Merge worktree back | `wt merge` |
| Remove worktree | `wt remove` |

### Worktrees + sesh

Each worktree becomes a tmux session via sesh:

```bash
# Create worktrees
wt switch --create feature-x
wt switch --create bugfix-y

# Each worktree = a sesh session
sesh connect ~/repos/myproject/feature-x
sesh connect ~/repos/myproject/bugfix-y

# Switch between them with Ctrl-A o
```

### Worktrees + Claude Code

Worktrees are especially useful with AI agents. Run Claude Code in one worktree while you work in another — completely isolated branches, no conflicts:

```bash
wt switch --create ai-refactor    # Claude Code works here
wt switch --create manual-fix     # You work here
# Both run in parallel, different tmux sessions
```

## Configuration

### sesh.toml

Located at `~/.config/sesh/sesh.toml`. Add project directories:

```toml
[[session]]
name = "dotfiles"
path = "~/repos/dotfiles"

[[session]]
name = "myproject"
path = "~/repos/myproject"
startup_command = "nvim"
```

### sessionx (tmux plugin)

Configured in `tmux.conf`:
- `@sessionx-bind 'o'` — key to open (after prefix)
- `@sessionx-zoxide-mode 'on'` — include zoxide results
- `@sessionx-custom-paths '~/repos/dotfiles'` — always show this path

## Troubleshooting

**wt command not found:**
Install via Homebrew (`brew install worktrunk`) or download the binary from the GitHub releases page.

**Worktree conflicts:**
If `wt merge` fails, resolve conflicts in the worktree directory like a normal merge, then retry.

## Reference

- sesh: `sesh --help`, https://github.com/joshmedeski/sesh
- worktrunk: `wt --help`, https://github.com/max-sixty/worktrunk
- git worktrees (underlying feature): `git worktree --help`
- sessionx: https://github.com/omerxx/tmux-sessionx
