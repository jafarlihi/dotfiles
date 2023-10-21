mount -t virtiofs shared /home/user2/shared/
systemctl restart sshd
echo 'nameserver 8.8.8.8' > /etc/resolv.conf
