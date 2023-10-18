# history options (man zshoptions)
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_FUNCTIONS
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Completion {{{
# https://thevaluable.dev/zsh-completion-guide-examples/
autoload -U compinit; compinit

# +--------+
# | PROMPT |
# +--------+

fpath=($DOTFILES/zsh/prompt $fpath)
source $DOTFILES/zsh/prompt/prompt_purification_setup

# +------------+
# | COMPLETION |
# +------------+

source $DOTFILES/zsh/completion.zsh

# +-----+
# | FZF |
# +-----+

if [ $(command -v "fzf") ]; then
    source $DOTFILES/zsh/fzf.zsh
fi

# +-----------+
# | FUNCTIONS |
# +-----------+

source $DOTFILES/zsh/functions/basic


# +---------+
# | ALIASES |
# +---------+
# Some alias depend on basic functions

source $DOTFILES/zsh/aliases/aliases
