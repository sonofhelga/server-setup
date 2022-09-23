#!/bin/bash

echo "i hope you're root or you're gonna have a bad time."
sleep 3
clear

echo "what would you like your new username to be?"
read name

echo "great, username is $name"
sleep 1

clear
echo "starting setup -- gonna need some creds in a second"
sleep 1


apt update -y && apt full-upgrade

apt install nano

apt install unattended-upgrades && dpkg-reconfigure --priority=low unattended-upgrades

useradd -m -s /bin/bash $name && passwd $name

echo "check which group we want to add for sudo access."
sleep 3

EDITOR=nano visudo

echo "which group did we want to add for sudo usage? (its probably just 'sudo'"
read group

usermod -aG $group $name

groups $name
echo "look correct?"
sleep 3
clear

echo "good."
sleep 1
clear

echo "lets make sure things are working"
su $name

sudo apt update -y

exit
clear
echo "take this:"
echo "ssh-copy-id -i ~/.ssh/id_rsa.pub $name@" 
echo "go ahead and send over your ssh creds, just fill in the ip ill wait."
echo "(but dont close this terminal)"
echo ""
ip a | grep inet
echo "press enter when ready to go"
read waiting

clear
echo 'make sure to test that ssh is working without a password, there is no going back.'
echo "press enter when ready to go"
read waiting

clear
systemctl restart sshd

apt install fail2ban -y

cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local

cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local