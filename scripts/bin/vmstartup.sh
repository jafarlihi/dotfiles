xrandr --output Virtual-1 --mode 1680x1050
opentcp 22 192.168.23.0/24
ip addr add 192.168.23.2/24 dev enp2s0
ip route add default via 192.168.23.1 dev enp2s0
mount -t virtiofs shared /home/user2/shared/
systemctl restart sshd
echo 'nameserver 8.8.8.8' > /etc/resolv.conf
