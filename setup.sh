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
su root
./scripts/enablesec
exit
ln -s `pwd`/scripts ~/bin
ln -s /var/lib/libvirt/images ~/kvm
sudo chown -R root:root scripts
sudo chown -R root:root ~/bin
EDITOR=nvim sudo visudo
sudo cp ./static/resolvconf.conf /etc/.
sudo resolvconf -u
sudo cp ./static/main.conf /etc/iwd/.
sudo systemctl restart iwd
