function _fuzzy_history {
  zle push-input

  # fc
  # -l = display the command list
  # -1 0 = (when used with -l) build the list from the most recent command (-1)
  #        back to the oldest command (0)
  #
  # fzf
  # +s = sort the input (based on the zsh command number)
  # -x = extended-search mode
  # -e = enable exact match
  BUFFER=$(fc -l -1 0 | fzf +s -x -e --preview-window=hidden --height 40%)

  # place the command on the command line with the cursor at the end of the line
  zle vi-fetch-history -n $BUFFER
  zle end-of-line
  zle reset-prompt

  # or... just execute the history command immediately
  # zle accept-line
}


zle -N _fuzzy_history
bindkey '^r' _fuzzy_history
# }}}

# FZF {{{
FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
