#!/bin/bash

# Display "GOOGLE DEBUNKER" in big font
echo "GOOGLE DEBUNKER" | figlet

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
cat <<EOF | sudo tee /etc/ssh/sshd_config > /dev/null
  #
  # Copyright 2015 Google Inc. All Rights Reserved.
  #
  # Licensed under the Apache License, Version 2.0 (the "License");
  # you may not use this file except in compliance with the License.
  # You may obtain a copy of the License at
  #
  #     http://www.apache.org/licenses/LICENSE-2.0
  #
  # Unless required by applicable law or agreed to in writing, software
  # distributed under the License is distributed on an "AS IS" BASIS,
  # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  # See the License for the specific language governing permissions and
  # limitations under the License.
  #
  # Package generated configuration file
  # See the sshd_config(5) manpage for details
  #
  
  # What ports, IPs and protocols we listen for
  Port 22
  # Use these options to restrict which interfaces/protocols sshd will bind to
  #ListenAddress ::
  #ListenAddress 0.0.0.0
  Protocol 2
  # HostKeys for protocol version 2
  HostKey /etc/ssh/ssh_host_rsa_key
  HostKey /etc/ssh/ssh_host_dsa_key
  HostKey /etc/ssh/ssh_host_ecdsa_key
  #Privilege Separation is turned on for security
  UsePrivilegeSeparation yes
  
  # Lifetime and size of ephemeral version 1 server key
  KeyRegenerationInterval 3600
  ServerKeyBits 768
  
  # Logging
  SyslogFacility AUTH
  LogLevel INFO
  
  # Authentication:
  LoginGraceTime 120
  PermitRootLogin yes
  StrictModes no
  
  RSAAuthentication yes
  PubkeyAuthentication yes
  #AuthorizedKeysFile     %h/.ssh/authorized_keys
  
  # Don't read the user's ~/.rhosts and ~/.shosts files
  IgnoreRhosts yes
  # For this to work you will also need host keys in /etc/ssh_known_hosts
  RhostsRSAAuthentication no
  # similar for protocol version 2
  HostbasedAuthentication no
  # Uncomment if you don't trust ~/.ssh/known_hosts for RhostsRSAAuthentication
  #IgnoreUserKnownHosts yes
  
  # To enable empty passwords, change to yes (NOT RECOMMENDED)
  PermitEmptyPasswords no
  
  # Change to yes to enable challenge-response passwords (beware issues with
  # some PAM modules and threads)
  ChallengeResponseAuthentication no
  
  # Change to no to disable tunnelled clear text passwords
  PasswordAuthentication no
  
  # Kerberos options
  #KerberosAuthentication no
  #KerberosGetAFSToken no
  #KerberosOrLocalPasswd yes
  #KerberosTicketCleanup yes
  
  # GSSAPI options
  #GSSAPIAuthentication no
  #GSSAPICleanupCredentials yes
  
  X11Forwarding yes
  X11DisplayOffset 10
  PrintMotd no
  PrintLastLog no
  TCPKeepAlive yes
  #UseLogin no
  
  MaxAuthTries 8
  MaxStartups 10:30:60
  #Banner /etc/issue.net
  
  # Allow client to pass locale environment variables
  AcceptEnv LANG LC_* DEVSHELL_PROJECT_ID GOOGLE_CLOUD_PROJECT GOOGLE_CLOUD_QUOTA_PROJECT CLOUDSHELL_OPEN_DIR
  
  Subsystem sftp /usr/lib/openssh/sftp-server
  
  # Set this to 'yes' to enable PAM authentication, account processing,
  # and session processing. If this is enabled, PAM authentication will
  # be allowed through the ChallengeResponseAuthentication and
  # PasswordAuthentication. Depending on your PAM configuration,
  # PAM authentication via ChallengeResponseAuthentication may bypass
  # the setting of "PermitRootLogin without-password".
  # If you just want the PAM account and session checks to run without
  # PAM authentication, then enable this but set PasswordAuthentication
  # and ChallengeResponseAuthentication to 'no'.
  UsePAM yes

  # Make sure to include "hmac-md5" MAC format.
  MACs hmac-md5,umac-64-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha1-etm@openssh.com,umac-64@openssh.com,umac-128@openssh.com,hmac-sha2-256,hmac-sha2-512,hmac-sha1
EOF


# Configure firewall
sudo ufw allow 22
sudo ufw allow 6000
sudo ufw allow 445

# Final instructions to run commands
echo "-------------------------------------------------"
echo "To complete the setup, run the following commands:"
echo "  sudo /etc/default/tailscaled"
echo "  sudo /etc/pam.d/sshd"
echo "-------------------------------------------------"
