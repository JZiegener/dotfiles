# Stage 2.5: Neovim + LazyVim

## Why Before Other Tools

Neovim is the `$EDITOR` that everything else integrates with:
- **yazi** opens files in `$EDITOR`
- **lazygit** opens files in `$EDITOR`
- **television** pipes selections to `$EDITOR`
- **opencode** embeds in neovim
- **tmux** uses `$EDITOR` for copy-mode editing

## What's Installed

**LazyVim** — a batteries-included neovim distribution. It provides:
- Plugin management (lazy.nvim)
- LSP (language server protocol) for code intelligence
- Telescope (fuzzy finder)
- Treesitter (syntax highlighting)
- Which-key (keybinding discovery)
- And ~30 more pre-configured plugins

## Getting Started

```bash
# Install
./install/install-stage2.5-neovim.sh

# First launch — plugins auto-install
nvim

# Health check
:checkhealth

# Update EDITOR in your shell
export EDITOR=nvim
```

On first launch, LazyVim downloads and installs all plugins. This takes 1-2 minutes. Watch the status bar at the bottom.

## Key Concepts

### Leader Key

LazyVim uses **Space** as the leader key. Most commands start with `Space + ...`.

Press `Space` and wait — **which-key** shows you all available commands.

### Modes

| Mode | Enter | Exit |
|------|-------|------|
| Normal | `Esc` or `jj` or `jk` | — |
| Insert | `i`, `a`, `o` | `Esc`/`jj`/`jk` |
| Visual | `v` (char), `V` (line) | `Esc` |
| Command | `:` | `Enter`/`Esc` |

## Essential Keybindings

### Navigation

| Action | Keys |
|--------|------|
| Find file | `Space f f` |
| Find in files (grep) | `Space s g` |
| File explorer | `Space e` |
| Recent files | `Space f r` |
| Buffers | `Space b b` |
| Go to definition | `gd` |
| Go to references | `gr` |
| Go back | `Ctrl-o` |
| Go forward | `Ctrl-i` |

### Editing

| Action | Keys |
|--------|------|
| Comment line | `gcc` |
| Comment selection | `gc` (in visual) |
| Surround add | `sa` + motion + char |
| Surround delete | `sd` + char |
| Surround replace | `gsr` + old + new |
| Format file | `Space c f` |
| Rename symbol | `Space c r` |
| Code actions | `Space c a` |

### Windows and Buffers

| Action | Keys |
|--------|------|
| Split vertical | `Space w v` or `Ctrl-w v` |
| Split horizontal | `Space w s` or `Ctrl-w s` |
| Navigate windows | `Ctrl-h/j/k/l` |
| Close window | `Space w d` |
| Close buffer | `Space b d` |
| Next buffer | `]b` |
| Previous buffer | `[b` |

### LSP (Code Intelligence)

| Action | Keys |
|--------|------|
| Hover documentation | `K` |
| Go to definition | `gd` |
| Go to declaration | `gD` |
| Go to implementation | `gI` |
| Go to type definition | `gy` |
| Signature help | `gK` |
| Diagnostics (current line) | `Space c d` |
| Next diagnostic | `]d` |
| Previous diagnostic | `[d` |

### Telescope (Fuzzy Finder)

| Action | Keys |
|--------|------|
| Find files | `Space f f` |
| Grep | `Space s g` |
| Buffers | `Space b b` |
| Help tags | `Space s h` |
| Keymaps | `Space s k` |
| Commands | `Space s c` |

In Telescope picker:
- `Ctrl-j/k` — navigate results
- `Enter` — select
- `Ctrl-v` — open in vertical split
- `Ctrl-x` — open in horizontal split
- `Esc` — close

### Plugin Management

| Action | Command |
|--------|---------|
| Open Lazy UI | `:Lazy` |
| Update plugins | `:Lazy update` |
| Sync plugins | `:Lazy sync` |
| Health check | `:checkhealth` |

## Go Development

The config includes gopls LSP with:
- **Auto-import** — missing imports are added on save
- **Static analysis** — unused parameters flagged
- **gofumpt** — stricter formatting than gofmt
- **Placeholders** — function signatures with parameter names

## Migrating from Vim

Your old vim habits still work:
- `:w` to save, `:q` to quit, `:wq` to save+quit
- `hjkl` navigation
- Visual mode with `v` and `V`
- Search with `/` and `?`
- Macros with `q`

New muscle memory to build:
- `Space` instead of `:` for most actions
- `gd` for go-to-definition (replaces ctags)
- `Space e` for file explorer (replaces NERDTree `Ctrl-T`)
- `Space f f` for file finding (replaces `:edit`)

## Customizing

Add plugins: create a file in `~/.config/nvim/lua/plugins/` returning a plugin spec.

```lua
-- Example: ~/.config/nvim/lua/plugins/myplugin.lua
return {
  "author/plugin-name",
  opts = {
    -- configuration
  },
}
```

## Troubleshooting

**Plugins failing to install:** Run `:checkhealth` to see what's missing. Common: need `gcc`, `make`, `node`, `npm`.

**LSP not working for Go:** Ensure `gopls` is installed: `go install golang.org/x/tools/gopls@latest`.

**Slow startup:** Run `:Lazy profile` to see which plugins are slow.

**Reset everything:** Delete `~/.local/share/nvim` and `~/.local/state/nvim`, then relaunch.

## Reference

- LazyVim docs: https://www.lazyvim.org/
- LazyVim keymaps: https://www.lazyvim.org/keymaps
- Neovim docs: `:help`, https://neovim.io/doc/
- lazy.nvim: https://github.com/folke/lazy.nvim
