#!/bin/bash

echo "setting up server, enter to continue"
read waiting

clear
echo "what would you like your new username to be?"
read name

clear
echo "great, username is $name"
sleep 1


clear
echo "which group did we want to add for sudo usage? (its probably just 'sudo')"
read group


clear
echo "im also going to need your ip address (this should be static)"
echo "can you fill this in w/ format xxx.xxx.xxx.xxx"
sudo ip a | grep inet
read ipaddress

clear
echo "okay, ip is $ipaddress"

clear
echo "starting setup."
sleep 1


sudo apt update -y && sudo apt full-upgrade -y

sudo apt install nano ufw curl -y

sudo apt install unattended-upgrades && sudo dpkg-reconfigure --priority=low unattended-upgrades

clear
sudo useradd -m -s /bin/bash $name 
echo "what would you like your password to be?"
sudo passwd $name
sudo usermod -aG $group $name

clear
sudo groups $name
echo "look correct?"
echo "the top line shoud say: $name $group"
echo "enter to continue"
read waiting

clear
echo "good."
sleep 1


clear
echo "take this:"
echo "ssh-copy-id -i ~/.ssh/id_rsa.pub $name@$ipaddress" 
echo "go ahead and send over your ssh creds, ill wait."
echo "(but dont close this terminal)"
echo "press enter when ready to go"
read waiting

clear
echo 'make sure to test that ssh is working without a password, there is no going back.'
echo "press enter when ready to go"
read waiting

clear
sudo mv ./sshd_config /etc/ssh/sshd_config
sudo systemctl restart sshd

sudo apt install fail2ban -y

sudo cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local

sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

sudo ufw default allow outgoing
sudo ufw default deny incoming
sudo ufw allow ssh
sudo ufw enable

echo "about to remove root password, so just checking in."
echo "enter to continue."
read waiting

passwd -l root
reboot
