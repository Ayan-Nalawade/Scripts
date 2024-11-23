curl -fsSL https://tailscale.com/install.sh | sh && sudo tailscale up --auth-key=tskey-auth-kAY3TFtBo221CNTRL-AungQ1fgm6j6PibL8TfB7jyXY9EfHrFF --advertise-exit-node
apt-get update && sudo apt-get install openssh-server
apt install ufw -y
apt-get install docker.io -y

echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sysctl -p /etc/sysctl.d/99-tailscale.conf

sed -i '/^PubkeyAuthentication/c\PubkeyAuthentication yes' /etc/ssh/sshd_config
sed -i '/^PasswordAuthentication/c\PasswordAuthentication no' /etc/ssh/sshd_config

ufw allow 22
ufw allow 6000
ufw allow 445

mkdir /storage
chown -R nobody:nogroup /storage
chmod -R 0777 /storage

/etc/default/tailscaled
/etc/pam.d/sshd

docker run -it -p 445:445 -e "USER=cqqp" -e "PASS=09117518" -v "/home/example:/storage" cqqp/samba
