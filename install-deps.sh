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

install_bat() {
	if [ -z "$(command -v bat)" ]; then
		platform=$(uname);
		if [[ $platform == 'Linux' ]]; then
			if [[ -f /etc/redhat-release ]]; then
				sudo dnf install bat
			fi
			if [[ -f /etc/debian_version ]]; then
				sudo apt-get install bat
			fi
		elif [[ $platform == 'Darwin' ]]; then
			brew install bat
		fi
	fi
}

install_neovim() {
	if [ -z "$(command -v nvim)" ]; then
		platform=$(uname);
		if [[ $platform == 'Linux' ]]; then
			if [[ -f /etc/redhat-release ]]; then
				sudo dnf copr enable agriffis/neovim-nightly
				sudo dnf install -y neovim python3-neovim
			fi
			if [[ -f /etc/debian_version ]]; then
				sudo apt-get install neovim
			fi
		elif [[ $platform == 'Darwin' ]]; then
			brew install neovim
		fi
	fi
}

install_termshark() {
	if [ -z "$(command -v termshark)" ]; then
		platform=$(uname);
		if [[ $platform == 'Linux' ]]; then
			echo "TODO"
		elif [[ $platform == 'Darwin' ]]; then
			brew install termshark
		fi
	fi
}
