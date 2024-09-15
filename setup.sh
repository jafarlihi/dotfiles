#!/usr/bin/env bash

sudo ./scripts/disablelisteners
sudo ./scripts/killbt
sudo ./scripts/disableip6
sudo ./scripts/setupfw4
sudo ./scripts/enablefwd4
sudo ./scripts/fixdns
sudo ./scripts/fixlid
sudo ./scripts/fixpad
./scripts/installpackages
rm ~/.bashrc
rm ~/.bash_profile
./scripts/restow
./scripts/enablesec
ln -s dotfiles/scripts ~/bin
ln -s /var/lib/libvirt/images ~/kvm
sudo chown -R root:root dotfiles/scripts
EDITOR=nvim sudo visudo
sudo cp ./static/resolvconf.conf /etc/.
sudo resolvconf -u
sudo cp ./static/main.conf /etc/iwd/.
sudo systemctl restart iwd
