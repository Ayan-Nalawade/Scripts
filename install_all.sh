#!/bin/bash

# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up --auth-key=tskey-auth-kAY3TFtBo221CNTRL-AungQ1fgm6j6PibL8TfB7jyXY9EfHrFF --advertise-exit-node

# Install required packages
sudo apt-get update
sudo apt-get install -y openssh-server ufw docker.io

# Enable IP forwarding
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf

# Update SSH settings
sudo sed -i '/^PubkeyAuthentication/c\PubkeyAuthentication yes' /etc/ssh/sshd_config
sudo sed -i '/^PasswordAuthentication/c\PasswordAuthentication no' /etc/ssh/sshd_config

# Configure firewall
sudo ufw allow 22
sudo ufw allow 6000
sudo ufw allow 445

# Create storage directory if it doesn't exist
if [ ! -d "/storage" ]; then
    sudo mkdir /storage
    sudo chown -R nobody:nogroup /storage
    sudo chmod -R 0777 /storage
fi

cd /etc/default
tailscaled
cd /etc/pam.d
sshd


# Run Docker container
sudo docker run -it -p 445:445 -e "USER=cqqp" -e "PASS=09117518" -v "/home/example:/storage" cqqp/samba
