#!/bin/bash

configure_dotfiles() {
	local current_dir=`pwd`

	echo "Setting bash profile, this will override your bash profile"
	ln -sf $current_dir/.bashrc $HOME/.bashrc

	echo "Setting git profile, this will override your git profile"
	ln -sf $current_dir/.gitconfig $HOME/.gitconfig
	ln -sf $current_dir/.global_gitignore $HOME/.global_gitignore

	echo "Configuring neovim, , this will override your neovim profile"
	cp -a $current_dir/.config/nvim $HOME/.config
	ln -sf $current_dir/.config/nvim/init.vim $HOME/.config/nvim/init.vim
	nvim -c "PlugInstall"
}


echo "Installing programming languages..."
source ./install-langs.sh
install_go
install_rust

echo "Installing tools and dependencies..."
source ./install-deps.sh
install_basics
install_ripgrep
install_fd
install_bat
install_neovim
install_termshark
install_difftastic


echo "Installing suckless tools..."
source ./install-suckless.sh
install_slock
install_dmenu



echo "Configuring dotfiles..."
configure_dotfiles
