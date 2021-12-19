#!/usr/bin/env bash

sudo apt update && sudo full-upgrade -y
sudo apt install -y git

wget -o micro.deb https://github.com/zyedidia/micro/releases/download/v2.0.10/micro-2.0.10-amd64.deb
dpkg -i micro.deb -y

git clone https://github.com/cuckoosec/dotfiles
cd ./dotfiles || exit

echo "Installing needed packages"
sudo apt install -y "$(cat debian.server.packages)" --dry-run

echo "Copying SSH config files"
sudo cp ssh_config /etc/ssh/ssh_config
sudo cp sshd_config /etc/ssh/sshd_config

sudo cp ./dnsmasq.conf /etc/dnsmasq.conf

echo "Blocking a bunch of bullshit..."
curl https://someonewhocares.org/hosts/hosts | sudo tee -a /etc/hosts

sudo chsh -s /usr/bin/zsh "$USER" # change shell

echo "Linking dotfiles"
ln -s ./.tmux.conf ~/.tmux.conf # Setup tmux
ln -s ./.zshrc ~/.zshrc # Setup zsh

echo "Setting up firewall"
sudo ufw default deny outgoing comment 'deny all outgoing traffic'
sudo ufw default deny incoming comment 'deny all incoming traffic'
sudo ufw limit in ssh comment 'allow SSH connections in'
sudo ufw allow out ftp comment 'allow FTP traffic out'
sudo ufw allow out whois comment 'allow whois'
sudo ufw allow out 53 comment 'allow DNS calls out'
sudo ufw allow out 67 comment 'allow the DHCP client to update'
sudo ufw allow out 68 comment 'allow the DHCP client to update'
sudo ufw allow out 123 comment 'allow NTP out'
sudo ufw allow out http comment 'allow HTTP traffic out'
sudo ufw allow out https comment 'allow HTTPS traffic out'

echo "Restarting ssh"
sudo service sshd restart

echo "Enabling the firewall"
sudo ufw enable

