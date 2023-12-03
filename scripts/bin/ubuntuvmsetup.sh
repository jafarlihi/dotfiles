#!/usr/bin/env bash

### TODO: Not finished
### - sshd config
### - et cetera

sudo ip addr add 192.168.23.2/24 dev enp1s0
sudo ip addr add default via 192.168.23.1
sudo echo 'nameserver 8.8.8.8' > /etc/resolv.conf
sudo apt update
sudo apt upgrade
sudo apt install git dialog stow
sudo apt install spice-vdagent
sudo snap install nvim --classic
git clone https://github.com/jafarlihi/dotfiles
cd dotfiles/scripts/bin/.
rm ~/.bashrc
./restow
cp ./vmstartup.sh ~/.
