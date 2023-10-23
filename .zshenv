#!/usr/bin/env zsh

###############################
# EXPORT ENVIRONMENT VARIABLE #
###############################

export DOTFILES="$HOME/.config/dotfiles"

# zsh
export HISTSIZE=10000                   # Maximum events for internal history
export SAVEHIST=10000                   # Maximum events in history file

# editor
export EDITOR="nvim"
export VISUAL="nvim"

# Man pages
export MANPAGER='nvim +Man!'

# golang
export GOPATH="$HOME/.go"
export GOBIN="$HOME/.go/bin"

# rust
. "$HOME/.cargo/env"


# PATH
export PATH="$GOBIN:$PATH"              # GOBIN 
