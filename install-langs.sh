install_go() {
	if [ -z "$(command -v go)" ]; then
		curl -sSf https://raw.githubusercontent.com/owenthereal/goup/master/install.sh | sh
	fi
}

install_rust() {
	if [ -z "$(command -v cargo)" ]; then
		curl https://sh.rustup.rs -sSf | sh
	fi
	source ~/.cargo/env
}
