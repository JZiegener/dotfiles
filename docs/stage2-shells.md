# Stage 2: Shell Evaluation Sandbox

## Why Evaluate Shells

All four shells share the same cross-shell tools from Stage 1 — starship prompt, zoxide directory jumping, atuin history search. Switching shells changes the **interactive experience** (completions, autosuggestions, syntax, pipelines) without losing muscle memory for those core tools.

Your install scripts, backup scripts, and homelab infrastructure scripts are all bash/POSIX — they run via shebang (`#!/bin/bash`) regardless of your interactive shell. Changing your interactive shell does NOT break your scripts.

## The Four Options

### Bash — The Known Quantity

**What it is:** Your current shell. POSIX-compatible, universal on Linux.

**Advantages:**
- Zero learning curve — you already know it
- Every script, tutorial, and StackOverflow answer is in bash
- Your `.bashrc` pathappend/pathprepend, WSL2 Docker setup, and all homelab scripts run natively
- Startup is fast (~20ms)

**Disadvantages:**
- No inline autosuggestions (you only see completions on Tab)
- Syntax highlighting requires a plugin (not built-in)
- Scripting syntax is ugly: `if [ "$x" -gt 0 ]; then ... fi`
- Error handling is fragile (`set -e` has well-known footguns)

**For your workflow:**
- Claude Code runs in bash by default — zero friction
- Every homelab script you write will work without thinking about compatibility
- But the interactive experience is the weakest of the four

**Learning curve:** None. You're already here.

### Zsh — Bash But Better

**What it is:** Bash-compatible shell with better interactive features. Default on macOS, huge plugin ecosystem.

**Advantages:**
- 95% compatible with bash syntax — your muscle memory transfers
- **Inline autosuggestions** — previous commands appear in grey as you type, press Right to accept
- **Syntax highlighting** — valid commands green, invalid red, before you press Enter
- Case-insensitive tab completion out of the box
- Shared history with deduplication across sessions
- Glob qualifiers: `ls **/*.cs` recursively, `ls *(.)` files only

**Disadvantages:**
- Plugin ecosystem (oh-my-zsh, zinit, etc.) is a rabbit hole — easy to overconfigure
- Slightly slower startup than bash (~40-80ms, depends on plugins)
- Some bash-specific syntax doesn't transfer (`$RANDOM` works, but `[[ ]]` behaves slightly differently)
- Completion system is powerful but complex to customize

**For your workflow:**
- Autosuggestions are the single biggest quality-of-life upgrade for frequent terminal use
- Claude Code works identically in zsh
- Your homelab scripts all work (zsh is POSIX-ish enough for everything in your repo)
- The `.zshrc` in this repo is minimal — vi mode, autosuggestions, syntax highlighting, git aliases, cross-shell tools. No plugin framework bloat.

**Learning curve:** Low. A few days of "why is this different" moments, then it's second nature. If you know bash, you know 95% of zsh.

### Fish — Best Out of Box, Different Language

**What it is:** User-friendly shell designed for interactive use. NOT POSIX-compatible.

**Advantages:**
- **Everything works immediately** — autosuggestions, syntax highlighting, completions, all built-in with zero config
- Best tab completion of any shell — parses man pages for flag completions automatically
- Syntax highlighting is richer than zsh (distinguishes valid paths, parameters, etc.)
- `fish_config` opens a web UI for theming and configuration
- Universal variables persist across all sessions: `set -U MY_VAR value`
- Error messages are actually helpful

**Disadvantages:**
- **Not POSIX** — different syntax for everything:
  - `set x 5` not `x=5`
  - `set -gx` not `export`
  - `if test $x -gt 0` not `if [ $x -gt 0 ]`
  - `function name; ...; end` not `function name() { }`
  - No `&&` — use `; and` or `&&` (added in fish 3.0 but feels bolted on)
- You'll constantly context-switch between fish (interactive) and bash (scripts, one-liners from docs)
- StackOverflow answers need mental translation
- Smaller community than bash/zsh

**For your workflow:**
- The out-of-box experience is genuinely excellent — if you want to spend zero time configuring your shell, fish wins
- But every bash one-liner from ChatGPT, Claude, or documentation needs translation
- Your homelab scripts run fine (they have `#!/bin/bash` shebangs) but you can't paste bash snippets directly into fish
- Claude Code should work fine in fish, but any shell commands it suggests will be bash syntax

**Learning curve:** Medium. The interactive experience is immediately better, but you'll hit friction every time you try to do something "the bash way." Unlearning bash habits takes weeks.

### Nushell — A Different Paradigm

**What it is:** A shell built around structured data. Commands output tables, not text. Pipelines pass records and lists, not strings. It's closer to PowerShell's philosophy than traditional Unix shells.

**Advantages:**
- **Structured data pipelines** — `ls` returns a table you can filter, sort, group:
  ```nu
  ls | where size > 1mb | sort-by modified
  open config.json | get database.host
  ```
- Built-in data format parsing (JSON, YAML, TOML, CSV, INI)
- Type system — catches errors before execution
- Immutable variables by default (safer scripting)
- Built-in `help` that's actually comprehensive: `help commands | where category == "strings"`
- Modern language design — closures, pattern matching, records

**Disadvantages:**
- **Not POSIX at all** — fundamentally different language:
  - `let x = 5` not `x=5` (and it's immutable)
  - `$env.PATH` not `$PATH`
  - No `&&` — use `;` or `try { }`
  - Completely different control flow syntax
- **Breaks your muscle memory** — you'll type bash reflexively and it won't work
- External commands lose structure — piping to/from non-nu programs falls back to text
- Smaller ecosystem, fewer examples online
- Startup is slower (~100-200ms)
- Config is more complex (the `config.nu` in this repo is 200+ lines for basic setup)

**For your workflow:**
- **Homelab data wrangling** is where nu shines — parsing JSON API responses, filtering log files, querying structured config. If you spend time processing JSON from APIs, docker inspect output, or config files, nu pipelines are dramatically faster than `jq` + `grep` + `awk` chains
- **But** every time you paste a bash command from docs, Claude, or tutorials, you'll need to translate
- Claude Code generates bash — you'd need to mentally translate or run a bash subshell
- Your WireGuard, backup, and Ollama scripts won't run in nu (but they have shebangs, so you'd call them as external commands)

**Learning curve:** High. This isn't "bash but different syntax" — it's a different mental model. Budget 2-4 weeks of regular use before it feels natural. The payoff is real but the cost is front-loaded.

## Comparison Matrix

| Feature | Bash | Zsh | Fish | Nushell |
|---------|------|-----|------|---------|
| **Autosuggestions** | No | Plugin | Built-in | Built-in |
| **Syntax highlighting** | No | Plugin | Built-in | Built-in |
| **Tab completion** | Basic | Excellent | Best | Good |
| **POSIX compatible** | Yes | Mostly | No | No |
| **Startup time** | ~20ms | ~40-80ms | ~30-50ms | ~100-200ms |
| **Structured data** | No | No | No | Yes |
| **Paste bash one-liners** | Yes | Yes | No | No |
| **Config complexity** | Medium | Medium | Low | High |
| **Vi mode** | Yes | Yes | Yes | Yes |
| **Learning curve** | None | Low | Medium | High |
| **Homelab scripts run natively** | Yes | Yes | No* | No* |

*Scripts with `#!/bin/bash` shebang run as external commands in any shell — they just can't be pasted inline.

## Recommendation for Your Profile

You're a developer who uses Claude Code daily, manages homelabs, and wants keyboard efficiency.

**Pragmatic choice: Zsh.** You get autosuggestions and syntax highlighting (the two biggest interactive upgrades) with almost zero relearning. All your scripts and bash habits transfer. Claude Code works identically.

**Interesting experiment: Nushell for data tasks.** Don't use it as your daily driver, but open a nu window when you're parsing JSON, filtering logs, or wrangling config files. The structured pipeline model is genuinely powerful for homelab administration. Think of it as a better `jq` + `awk`, not a bash replacement.

**Fish** is excellent but the POSIX incompatibility creates daily friction for someone who pastes bash commands frequently (from Claude, docs, StackOverflow).

You don't have to choose one. A practical setup:
- **Login shell:** bash (compatibility, your scripts)
- **tmux default:** zsh (better interactive experience)
- **Data tasks:** nushell in a dedicated tmux window

To set tmux's default shell without changing login shell:
```tmux
# In tmux.conf:
set -g default-shell /usr/bin/zsh
```

## How to Evaluate

Open each shell in a separate tmux window:

```bash
# In tmux:
tmux new-window -n bash 'bash'
tmux new-window -n zsh 'zsh'
tmux new-window -n nu 'nu'
tmux new-window -n fish 'fish'

# Switch between them: Ctrl-A H / Ctrl-A L
```

### Test These Scenarios

**1. Autosuggestions** — type a partial command you've run before
- zsh/fish: suggestion appears in grey, press Right arrow to accept
- nushell: completion menu appears
- bash: nothing happens until Tab

**2. Tab completion** — type `git ch` then Tab
- All shells complete differently — notice the speed and presentation

**3. Paste a bash one-liner** — try `for i in {1..5}; do echo $i; done`
- bash/zsh: works
- fish: syntax error
- nushell: syntax error

**4. Data pipeline** — try filtering some JSON:
- bash: `cat file.json | jq '.items[] | select(.size > 100)'`
- nushell: `open file.json | get items | where size > 100`

**5. Homelab script** — try running one of your install scripts:
- All shells: `bash install/install-stage1-foundation.sh` works (explicit bash call)
- bash/zsh: `./install/install-stage1-foundation.sh` works (shebang)
- fish/nu: `./install/install-stage1-foundation.sh` works (shebang, runs bash subprocess)

**6. Startup time:**
```bash
time bash -i -c exit
time zsh -i -c exit
time fish -c exit
time nu -c exit
```

## Getting Help

| Shell | Help command | Documentation |
|-------|-------------|---------------|
| bash | `man bash`, `help <builtin>` | https://www.gnu.org/software/bash/manual/ |
| zsh | `man zshbuiltins`, `man zshall` | https://zsh.sourceforge.io/Doc/ |
| nushell | `help`, `help commands`, `help <cmd>` | https://www.nushell.sh/book/ |
| fish | `help` (opens browser), `man fish` | https://fishshell.com/docs/current/ |

## Config File Locations

| Shell | Config file | Stow package |
|-------|------------|-------------|
| bash | `~/.bashrc` | `bash/.bashrc` |
| zsh | `~/.zshrc` | `zsh/.zshrc` |
| nushell | `~/.config/nushell/{config.nu,env.nu}` | `nushell/.config/nushell/` |
| fish | `~/.config/fish/config.fish` | `fish/.config/fish/config.fish` |
