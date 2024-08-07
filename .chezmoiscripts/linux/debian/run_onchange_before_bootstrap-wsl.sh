#!/bin/bash
if [ "$INSTALLATION_TYPE" != "wsl" ]; then
  echo "🚫 This script is only intended to run on WSL."
  exit 1
fi

echo "🔧 Enabling OpenSSH on WSL..."
sudo apt remove -y --purge openssh-server
sudo apt install -y openssh-server
sudo sed -i 's/#Port 22/Port 2222/g' /etc/ssh/sshd_config
sudo sed -i 's/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/g' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sudo grep -qxF 'AllowUsers benc' /etc/ssh/sshd_config || echo 'AllowUsers benc' | sudo tee -a /etc/ssh/sshd_config
sudo service ssh --full-restart
sudo grep -qxF '%sudo ALL=NOPASSWD: /etc/init.d/ssh' /etc/sudoers || echo '%sudo ALL=NOPASSWD: /etc/init.d/ssh' | sudo EDITOR='tee -a' visudo

sudo touch /etc/wsl.conf
sudo grep -qxF '[boot]' /etc/wsl.conf || echo '[boot]' | sudo tee -a /etc/wsl.conf
sudo grep -qxF 'command = service ssh start' /etc/wsl.conf || echo 'command = service ssh start' | sudo tee -a /etc/wsl.conf

# you can access the SSH server through proxyjump
echo "🔐 Enabling piping of 1password SSH agent to WSL..."
sudo apt install -y socat
