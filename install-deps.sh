install_ripgrep() {
	if [ -z "$(command -v rg)" ]; then
	  platform=$(uname);
	  if [[ $platform == 'Linux' ]]; then
	    if [[ -f /etc/redhat-release ]]; then
	      sudo dnf install ripgrep 
	    elif [[ -f /etc/debian_version ]]; then
	      sudo apt-get install ripgrep 
	    fi
	  elif [[ $platform == 'Darwin' ]]; then
	   brew install ripgrep 
	  fi
	fi
}

install_fd() {
	if [ -z "$(command -v fd)" ]; then
	  platform=$(uname);
	  if [[ $platform == 'Linux' ]]; then
	    if [[ -f /etc/redhat-release ]]; then
	      sudo dnf install fd-find
	    elif [[ -f /etc/debian_version ]]; then
	      sudo apt-get install fd-find 
	    fi
	  elif [[ $platform == 'Darwin' ]]; then
	   brew install fd 
	  fi
	fi
}
