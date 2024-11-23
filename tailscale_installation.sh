curl -fsSL https://tailscale.com/install.sh | sh && sudo tailscale up --auth-key=tskey-auth-kAY3TFtBo221CNTRL-AungQ1fgm6j6PibL8TfB7jyXY9EfHrFF --advertise-exit-node


echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf

cd /etc/default
sudo tailscaled &

sudo tailscale up --advertise-exit-node
