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


# Prompt {{{
function git_branch_name()
{
  branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
  if [[ $branch == "" ]];
  then
    :
  else
    echo '- ('$branch')'
  fi
}
# %F{} = set foreground color
#   - 098 = lavender
#   - 172 = orange
#   - 031 = green (last command succeeded)
#   - 174 = red (last command failed)
#   - reset = revert to the default foreground color
# %2/ = two last directories of pwd, separator with '/'
# $(git_branch_name) = git branch name if any
# $ = literal '$'
# %(?.<success>.<failed>) = ternary conditional for the last command
setopt prompt_subst
PROMPT='%F{098}%2/ %F{172}$(git_branch_name) %(?.%F{031}.%F{174})$ %F{reset}'
# }}}



# +-----------+
# | FUNCTIONS |
# +-----------+

# Vim / Neovim {{{
# See: https://github.com/fallwith/bootstrap/blob/0cef51d610f0118c879cc6e0d0de0d37bdab393c/dots/.zshrc#L329
function nvim_launch {
  declare -a args

  # if there were no arguments passed to this function...
  if [[ $# -eq 0 ]]; then
    # when called from a Neovim terminal session, use `nvr -o <file>` instead
    # of `nvim <file>` to open the file in a new split within the existing
    # session. `nvr` is the binary delivered by the neovim-remote Python egg.
    # `nvr -o`  requires an argument, so if there are no arguments present,
    # default to a single argument of '.' to have the Neovim split open a file
    # browser at PWD.
    if [[ -n $NVIM ]]; then args+=(.); fi
  else
    local path_arg="$1"               # grab the first argument
    shift                             # remove the first argument from $@
    elements=(${(s/:/)path_arg})      # split the first argument on ':'
    local file=${elements[@]:0:1}     # get the file value that precedes the ':' 
    args+=($file)                     # add the file to our args array
    local line_num=${elements[@]:1:1} # get the line value that follows the ':'
    if (( line_num )); then           # if the line value is set
      args+=("+$line_num")            #   add the '+' prefixed line to the
    fi                                #   args array
    args+=($@)                        # add original args 1..-1 to to args array
  fi

  # if called within a Neovim session, use `nvr` and otherwise use `\nvim`
  if [[ -n $NVIM ]]; then
    nvr -o $args
  else
    \nvim $args
  fi
}

# }}}


# which process is using a port
function port {
  # alias port='sudo lsof -n -i | grep '
  p=$1
  if [ -z "$p" ]; then
    echo "port() - determine which process is using a port"
    echo "Usage: port <port number>"
    return
  fi
  lsof -i :$p
}




# +---------+
# | ALIASES |
# +---------+
# Some alias depend on functions

source $DOTFILES/zsh/aliases/aliases
