#!/usr/bin/bash
# shellcheck disable=SC1090


# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ---------------------- local utility functions ---------------------

_have()      { type "$1" &>/dev/null; }
_source_if() { [[ -r "$1" ]] && source "$1"; }

# ----------------------- environment variables ----------------------
#                           (also see envx)

export USER="$(whoami)"
export GITUSER="$USER"
export REPOS="$HOME/repos"
export GHREPOS="$REPOS/github.com/$GITUSER"
export DOTFILES="$GHREPOS/dotfiles"
export SCRIPTS="$DOTFILES/scripts"
export SNIPPETS="$DOTFILES/snippets"
export DESKTOP="$HOME/Desktop"
export DOCUMENTS="$HOME/Documents"
export DOWNLOADS="$HOME/Downloads"
export TEMPLATES="$HOME/Templates"
export PUBLIC="$HOME/Public"
export PRIVATE="$HOME/Private"
export PICTURES="$HOME/Pictures"
export MUSIC="$HOME/Music"
export VIDEOS="$HOME/Videos"
export PDFS="$DOCUMENTS/PDFS"
export VIRTUALMACHINES="$HOME/VirtualMachines"
export WORKSPACES="$HOME/Workspaces" # container home dirs for mounting
export TERM=xterm-256color
export GOPRIVATE="github.com/$GITUSER/*,gitlab.com/$GITUSER/*"
export GOPATH="/home/$USER"
export GOBIN="/usr/local/go/bin"
export GOPROXY=direct
export CGO_ENABLED=0
export EDITOR=vi
export VISUAL=vi
export RUSTPATH="$HOME/.cargo/env"

# ------------------------------- path -------------------------------
pathappend() {
  declare arg
  for arg in "$@"; do
    test -d "$arg" || continue
    PATH=${PATH//":$arg:"/:}
    PATH=${PATH/#"$arg:"/}
    PATH=${PATH/%":$arg"/}
    export PATH="${PATH:+"$PATH:"}$arg"
  done
} && export pathappend

pathprepend() {
  for arg in "$@"; do
    test -d "$arg" || continue
    PATH=${PATH//:"$arg:"/:}
    PATH=${PATH/#"$arg:"/}
    PATH=${PATH/%":$arg"/}
    export PATH="$arg${PATH:+":${PATH}"}"
  done
} && export pathprepend

pathprepend \
  "$GOBIN" \
  "$HOME/.local/bin" \
  "$GHREPOS/cmd-"* \
  "$SCRIPTS" 


pathappend \
  /usr/local/opt/coreutils/libexec/gnubin \
  /mingw64/bin \
  /usr/local/bin \
  /usr/local/sbin \
  /usr/local/games \
  /usr/games \
  /usr/sbin \
  /usr/bin \
  /snap/bin \
  /sbin \
  /bin \
  ~/repos/dotfiles/scripts \
  "$RUSTPATH"

# ------------------------------ cdpath ------------------------------

export CDPATH=".:$GHREPOS:$DOT:$REPOS:/media/$USER:$HOME"


# ------------------------------ history -----------------------------

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoreboth
export HISTSIZE=5000
export HISTFILESIZE=10000

# append to the history file, don't overwrite it
shopt -s histappend


# --------------------------- smart prompt ---------------------------
#                 (keeping in bashrc for portability)

PROMPT_LONG=40
PROMPT_MAX=95
PROMPT_AT=@

__ps1() {
  local P='$' dir="${PWD##*/}" B countme short long double\
    r='\[\e[31m\]' g='\[\e[32m\]' h='\[\e[36m\]' \
    u='\[\e[33m\]' p='\[\e[36m\]' w='\[\e[35m\]' \
    b='\[\e[36m\]' x='\[\e[0m\]'

  [[ $EUID == 0 ]] && P='#' && u=$r && p=$u # root
  [[ $PWD = / ]] && dir=/
  [[ $PWD = "$HOME" ]] && dir='~'

  B=$(git branch --show-current 2>/dev/null)
  [[ $dir = "$B" ]] && B=.
  countme="$USER$PROMPT_AT$(hostname):$dir($B)\$ "

  [[ $B = master || $B = main ]] && b="$r"
  [[ -n "$B" ]] && B="$g($b$B$g)"
  #echo ${#countme}
  short="$u\u$g$PROMPT_AT$h\h$g:$w$dir$B$p$P$x "
  long="$g╔ $u\u$g$PROMPT_AT$h\h$g:$w$dir$B\n$g╚ $u$P$x "
  double="$g╔ $u\u$g$PROMPT_AT$h\h$g:$w$dir\n$g║ $B\n$g╚ $u$P$x "

  if (( ${#countme} > PROMPT_MAX )); then
    PS1="$double"
  elif (( ${#countme} > PROMPT_LONG )); then
    PS1="$long"
  else
    PS1="$short"
  fi
}

# PROMPT_COMMAND="__ps1"  # replaced by starship (Stage 1)
# ------------------------------ aliases -----------------------------
#      (use exec scripts instead, which work from vim and subprocs)

alias ls='ls -h --color=auto'
alias free='free -h'
alias df='df -h'
alias chmox='chmod +x'
alias k='kanban'
alias code='flatpak run com.vscodium.codium'

# ---------------------------- WSL2 Docker Setup --------------------

if [[ ! -z "${WSL_DISTRO_NAME}" ]]; then
  export DOCKER_DISTRO=$WSL_DISTRO_NAME
  DOCKER_DIR=/mnt/wsl/shared-docker
  DOCKER_SOCK="$DOCKER_DIR/docker.sock"
  export DOCKER_HOST="unix://$DOCKER_SOCK"
  if [ ! -S "$DOCKER_SOCK" ]; then
    mkdir -pm o=,ug=rwx "$DOCKER_DIR"
    chgrp docker "$DOCKER_DIR"
    /mnt/c/Windows/System32/wsl.exe -d $DOCKER_DISTRO sh -c "nohup sudo -b dockerd < /dev/null > $DOCKER_DIR/dockerd.log 2>&1"
  fi
fi


# ----------------------------- functions ----------------------------

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# source bash_aliases if it exists
_source_if ~/.bash_aliases

# enable programmable completion features
if ! shopt -oq posix; then
  _source_if /usr/share/bash-completion/bash_completion || \
    _source_if /etc/bash_completion
fi

# ---------------------- cross-shell tools (Stage 1) ----------------------

# Starship prompt (replaces __ps1)
_have starship && eval "$(starship init bash)"

# Zoxide (frecency-based cd, use: z <partial-dir>)
_have zoxide && eval "$(zoxide init bash)"

# Atuin (shell history with SQLite, use: Ctrl-R)
_source_if "$HOME/.atuin/bin/env"
_have atuin && eval "$(atuin init bash)"
