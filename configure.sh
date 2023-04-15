#!/bin/bash

configure_dotfiles() {
	local current_dir=`pwd`

	echo "Setting bash profile, this will override your bash profile"
	ln -sf $current_dir/.bashrc $HOME/.bashrc

	echo "Setting git profile, this will override your git profile"
	ln -sf $current_dir/.gitconfig $HOME/.gitconfig
	ln -sf $current_dir/.global_gitignore $HOME/.global_gitignore

	echo "Setting tmux configuration file"
	ln -sf $current_dir/.tmux.conf $HOME/.tmux.conf

	echo "Setting alacritty configuration file"
    mkdir -p $HOME/.config/alacritty
	ln -sf $current_dir/.config/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml
}

configure_neovim() {
    git clone git@github.com:rogercoll/nvim.git $HOME/.config/nvim || cd ~/.config/nvim/ && git pull
}


echo "Configuring dotfiles..."
configure_dotfiles

echo "Configuring neovim..."
configure_neovim
