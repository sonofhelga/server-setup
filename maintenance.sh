#!/bin/bash

echo "i hope you're root or you're gonna have a bad time."
sleep 3

clear
echo "what would you like your new username to be?"
read name

clear
echo "great, username is $name"
sleep 1

clear
echo "check which group we want to add for sudo access."
sleep 3

EDITOR=nano visudo

clear
echo "which group did we want to add for sudo usage? (its probably just 'sudo'"
read group


clear
echo "im also going to need your ip address (this should be static)"
echo "can you fill this in w/ format xxx.xxx.xxx.xxx"
ip a | grep inet
read ipaddress

clear
echo "okay, ip is $ipaddress"

clear
echo "starting setup."
sleep 1


apt update -y && apt full-upgrade -y

apt install nano

apt install unattended-upgrades && dpkg-reconfigure --priority=low unattended-upgrades

useradd -m -s /bin/bash $name && passwd $name
usermod -aG $group $name

clear
groups $name
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
mv ./sshd_config /etc/ssh/sshd_config
systemctl restart sshd

apt install fail2ban -y

cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local

cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

echo "about to remove root password, so just checking in."
echo "enter to continue."
read waiting

sudo passwd -l root
