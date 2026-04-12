# ── Fish Configuration ───────────────────────────────────
# Evaluation shell — shares starship, zoxide, atuin with bash

# ── Environment ──────────────────────────────────────────
set -gx EDITOR vi
set -gx VISUAL vi
set -gx TERM xterm-256color

# ── Aliases ──────────────────────────────────────────────
alias ls='ls -h --color=auto'
alias ll='ls -lah'
alias free='free -h'
alias df='df -h'
alias chmox='chmod +x'
alias grep='grep --color=auto'

# ── Vi mode ──────────────────────────────────────────────
fish_vi_key_bindings

# ── Cross-shell tools (Stage 1) ─────────────────────────
if type -q starship
    starship init fish | source
end

if type -q zoxide
    zoxide init fish | source
end

if type -q atuin
    atuin init fish | source
end
