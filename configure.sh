#!/bin/bash

echo "Installing tools and dependencies..."
source ./install-deps.sh
install_ripgrep
install_fd
install_bat

echo "Installing programming languages..."
source ./install-langs.sh
install_go
install_rust
