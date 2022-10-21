#!/bin/bash

# Install deps
DEPLIST="`sed -e 's/#.*$//' -e '/^$/d' dependencies.txt | tr '\n' ' '`"
emerge --autounmask-continue -q $DEPLIST


# Create user
useradd -m -G users,wheel,audio -s /bin/bash neck
passwd
cp ../.bashrc /home/neck
chmod neck:neck /home/neck/.bashrc
echo "neck  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/neck

# Setup dwm and slstatus
su neck
cd /home/neck/.config
git clone https://github.com/rogercoll/dwm.git
sudo make clean install
