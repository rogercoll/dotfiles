#!/bin/bash

configure_dotfiles() {
	echo "Setting bash profile, this will override your bash profile"
	ln -sf $OLDPWD/.bashrc $HOME/.bashrc

	echo "Setting git profile, this will override your git profile"
	ln -sf $OLDPWD/.gitconfig $HOME/.gitconfig
	ln -sf $OLDPWD/.global_gitignore $HOME/.global_gitignore

	echo "Setting tmux configuration file"
	ln -sf $OLDPWD/.tmux.conf $HOME/.tmux.conf

	echo "Setting alacritty configuration file"
    mkdir -p $HOME/.config/alacritty
	ln -sf $OLDPWD/.config/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml
}

configure_neovim() {
    git clone git@github.com:rogercoll/nvim.git $HOME/.config/nvim || cd ~/.config/nvim/ && git pull
}

configure_tmux() {
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}


echo "Configuring neovim..."
configure_neovim

echo "Configuring tmux..."
configure_tmux

echo "Configuring dotfiles..."
configure_dotfiles

