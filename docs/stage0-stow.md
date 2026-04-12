# Stage 0: GNU Stow Setup

## What Changed

Your dotfiles are now managed by **GNU Stow** — a symlink farm manager. Instead of copying configs into place, stow creates symlinks from your home directory back to the repo. Edit the file in the repo, and the change is live immediately.

## How It Works

The repo is organized into **packages** — directories that mirror your home directory structure:

```
dotfiles/
  bash/              ← package
    .bashrc          ← stows to ~/.bashrc
  tmux/              ← package
    .config/tmux/
      tmux.conf      ← stows to ~/.config/tmux/tmux.conf
  vim/               ← package
    .vimrc           ← stows to ~/.vimrc
```

When you run `stow bash`, it creates `~/.bashrc → repos/dotfiles/bash/.bashrc`.

## Key Commands

| Action | Command |
|--------|---------|
| Deploy a package | `stow <package>` |
| Deploy all base packages | `./setup.sh` |
| Deploy specific packages | `./setup.sh bash tmux vim` |
| Remove a package | `stow -D <package>` |
| Re-deploy (unstow + stow) | `stow -R <package>` |
| Dry run (preview) | `stow --simulate --verbose <package>` |
| Check for conflicts | `stow --no <package>` |

## Getting Started

```bash
# Install stow
sudo apt install stow

# From the dotfiles repo:
cd ~/repos/dotfiles

# Deploy base configs
./setup.sh

# Or run the install script
./install/install-stage0-stow.sh
```

## Troubleshooting

**"CONFLICT: existing target is not owned by stow"**
A real file already exists at the target. Back it up and remove it:
```bash
mv ~/.bashrc ~/.bashrc.backup
stow bash
```

**"CONFLICT: existing target is a directory"**
A real directory exists where stow wants to create a symlink. Remove the directory first (after backing up its contents):
```bash
mv ~/.config/tmux ~/.config/tmux.backup
stow tmux
```

**Verify symlinks are correct:**
```bash
ls -la ~/.bashrc
# Should show: .bashrc -> repos/dotfiles/bash/.bashrc
```

## Adding New Configs

To add a new tool's config to stow management:

1. Create a package directory that mirrors the home directory path:
   ```bash
   mkdir -p toolname/.config/toolname
   ```
2. Put the config file in the right place:
   ```bash
   mv ~/.config/toolname/config.toml toolname/.config/toolname/config.toml
   ```
3. Stow it:
   ```bash
   stow toolname
   ```

## How .stowrc Works

The `.stowrc` file in the repo root sets defaults:
- `--target=/home/birch` — symlinks target your home directory
- `--ignore=\.stowrc` — don't try to stow the stowrc itself
- `--ignore=\.DS_Store` — ignore macOS artifacts

## Reference

- `man stow`
- GNU Stow manual: https://www.gnu.org/software/stow/manual/stow.html
