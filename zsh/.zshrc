# ── Zsh Configuration ────────────────────────────────────
# Evaluation shell — shares starship, zoxide, atuin with bash

# ── Completions ──────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── Autosuggestions ──────────────────────────────────────
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ── Vi mode ──────────────────────────────────────────────
bindkey -v
bindkey 'jj' vi-cmd-mode
export KEYTIMEOUT=20

# ── History ──────────────────────────────────────────────
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# ── Environment ──────────────────────────────────────────
export EDITOR=vi
export VISUAL=vi
export TERM=xterm-256color

# ── Aliases ──────────────────────────────────────────────
alias ls='ls -h --color=auto'
alias ll='ls -lah'
alias free='free -h'
alias df='df -h'
alias chmox='chmod +x'
alias grep='grep --color=auto'

# ── Cross-shell tools (Stage 1) ─────────────────────────
command -v starship >/dev/null && eval "$(starship init zsh)"
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
command -v atuin >/dev/null && eval "$(atuin init zsh)"
