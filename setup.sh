#!/bin/bash
set -e
echo -e "\e[32m
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#              Josh's Watermark Setup Script            #
#       This Script only works on Ubuntu & Debian       #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #\e[0m"

# Check if user is sudo
if [[ $EUID -ne 0 ]]; then
    echo -e "\e[32m* This script must be executed via sudo user. \e[0m" 1>&2
    exit 1
fi

# Proceed?
while true; do
    RESET="\e[0m"
    GREEN="\e[32m"
    read -p "$(echo -e $GREEN"\n* Do you want to proceed? (Y/N)"$RESET)" yn
    case $yn in
        [yY] ) echo -e "\e[32m* Confirmed. Continuing..\e[0m"; break;;
        [nN] ) echo -e "\e[32m* Confirmed. Exiting Installation..\e[0m"; exit;;
        * ) echo -e "\e[32m* Invalid Response.\e[0m";;
    esac
done

echo -e "\e[32m* Setting up watermark..\e[0m"
awk '/^#?Banner/{gsub(/#?Banner .*/, "Banner /etc/welcome"); found=1}1;END{if(!found) print "Banner /etc/welcome"}' /etc/ssh/sshd_config > /tmp/sshd_config_temp && sudo mv /tmp/sshd_config_temp /etc/ssh/sshd_config

echo -e "\n* Enter your domain (e.g., example.com):"
read -r host
# Setup MOTD
if [[ -f /etc/motd ]]; then
    echo -e "\e[32m* /etc/motd file found. Removing file..\e[0m"
    rm /etc/motd
else
    echo -e "\e[32m* /etc/motd file not found. Skipping removal.\e[0m"
fi

cat <<EOL | sudo tee -a /etc/motd > /dev/null

     ██╗ ██████╗ ███████╗██╗  ██╗███████╗███████╗██╗   ██╗███████╗██████╗  ██████╗ ███████╗   ███╗   ██╗███████╗████████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
     ██║██╔═══██╗██╔════╝██║  ██║██╔════╝██╔════╝██║   ██║██╔════╝██╔══██╗██╔═══██╗██╔════╝   ████╗  ██║██╔════╝╚══██╔══╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
     ██║██║   ██║███████╗███████║███████╗█████╗  ██║   ██║█████╗  ██████╔╝██║   ██║███████╗   ██╔██╗ ██║█████╗     ██║   ██║ █╗ ██║██║   ██║██████╔╝█████╔╝ 
██   ██║██║   ██║╚════██║██╔══██║╚════██║██╔══╝  ╚██╗ ██╔╝██╔══╝  ██╔══██╗██║   ██║╚════██║   ██║╚██╗██║██╔══╝     ██║   ██║███╗██║██║   ██║██╔══██╗██╔═██╗ 
╚█████╔╝╚██████╔╝███████║██║  ██║███████║███████╗ ╚████╔╝ ███████╗██║  ██║╚██████╔╝███████║██╗██║ ╚████║███████╗   ██║   ╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
 ╚════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝    ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
                                                                                                                                                            
This server is managed by: Josh Severo (joshsevero.dev)

Node ID: $host

Contact me: me@joshsevero.dev

EOL

if [[ -f /etc/welcome ]]; then
    echo -e "\e[32m* /etc/welcome file found. Removing file..\e[0m"
    rm /etc/welcome
else
    echo -e "\e[32m* /etc/welcome file not found. Skipping removal.\e[0m"
fi

cat <<EOL | sudo tee -a /etc/welcome > /dev/null

     ██╗ ██████╗ ███████╗██╗  ██╗███████╗███████╗██╗   ██╗███████╗██████╗  ██████╗ ███████╗   ███╗   ██╗███████╗████████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
     ██║██╔═══██╗██╔════╝██║  ██║██╔════╝██╔════╝██║   ██║██╔════╝██╔══██╗██╔═══██╗██╔════╝   ████╗  ██║██╔════╝╚══██╔══╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
     ██║██║   ██║███████╗███████║███████╗█████╗  ██║   ██║█████╗  ██████╔╝██║   ██║███████╗   ██╔██╗ ██║█████╗     ██║   ██║ █╗ ██║██║   ██║██████╔╝█████╔╝ 
██   ██║██║   ██║╚════██║██╔══██║╚════██║██╔══╝  ╚██╗ ██╔╝██╔══╝  ██╔══██╗██║   ██║╚════██║   ██║╚██╗██║██╔══╝     ██║   ██║███╗██║██║   ██║██╔══██╗██╔═██╗ 
╚█████╔╝╚██████╔╝███████║██║  ██║███████║███████╗ ╚████╔╝ ███████╗██║  ██║╚██████╔╝███████║██╗██║ ╚████║███████╗   ██║   ╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
 ╚════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝    ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
                                                                                                                                                            
WARNING: ANY UNAUTHORIZED ACCESS WILL BE LOGGED AND REPORTED TO THE AUTHORITIES IF NEEDED.

This server is managed by: Josh Severo (joshsevero.dev)

Node ID: $host

Contact me: me@joshsevero.dev

EOL

# Restart SSH
sudo systemctl restart ssh

echo -e "\e[32m* Domain setup completed\e[0m"
