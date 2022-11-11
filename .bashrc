# enable color support of ls and also add handy aliases
  if [ -x /usr/bin/dircolors ]; then
      test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
      alias ls='ls --color=auto'
      alias grep='grep --color=auto'
      alias fgrep='fgrep --color=auto'
      alias egrep='egrep --color=auto'
  fi
  
# append to the history file, don't overwrite it
 shopt -s histappend
# set globstar, the pattern ** used in a pathname expansion
 shopt -s globstar




#Alias
 alias tree='tree -C'
 alias ll='ls -alF'
 alias la='ls -A'
 alias l='ls -CF'
 alias docker=podman
 alias vim=nvim


#Addition alias
 alias myip='curl ifconfig.co'
 alias weather='curl wttr.in/barcelona?1'
 alias crypto='ssh cointop.sh'

#Simple color prompt
export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
