#!/usr/bin/env bash

sudo ./scripts/disablelisteners
sudo ./scripts/killbt
sudo ./disableip6
sudo ./setupfw4
sudo ./enablefwd4
sudo ./fixdns
sudo ./fixlid
sudo ./fixpad
./installpackages
rm ~/.bashrc
rm ~/.bash_profile
./restow
./enablesec
ln -s dotfiles/scripts ~/bin
ln -s /var/lib/libvirt/images ~/kvm
sudo chown -R root:root dotfiles/scripts
EDITOR=nvim sudo visudo
sudo cp ./static/resolvconf.conf /etc/.
sudo resolvconf -u
sudo cp ./static/main.conf /etc/iwd/.
sudo systemctl restart iwd
