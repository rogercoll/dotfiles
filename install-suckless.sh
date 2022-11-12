#!/usr/bin/env bash


# So that when a command fails, bash exits.
set -o errexit

# This will make the script fail, when accessing an unset variable.
set -o nounset

# the return value of a pipeline is the value of the last (rightmost) command
# to exit with a non-zero status, or zero if all commands in the pipeline exit
# successfully.
set -o pipefail

# This helps in debugging your scripts. TRACE=1 ./script.sh
if [[ "${TRACE-0}" == "1" ]]; then set -o xtrace; fi



install_slock() {
   local tool="slock"
   git clone https://github.com/rogercoll/$slock.git $HOME/.config/$tool
   (cd $HOME/.config/$tool && sudo make clean install)
}

install_dmenu() {
   local tool="dmenu"
   git clone https://git.suckless.org/$tool $HOME/.config/$tool
   (cd $HOME/.config/$tool && sudo make clean install)
}
