#!/bin/bash
#
# This script file is used in ubuntu 20.04 to modify the working environment to be suitable for installing GD-CRM system.
#

echo "###############################################################################"
echo "Update our machine to the latest code if we need to. "
echo "###############################################################################"

# if user id not equal to 0 then print error message to standard error.
if [ "$(id -u)" -ne 0 ]; then
    # &2 => Standard Error
    # &1 => Standard Output
    echo 'This script must be run with root privileges' >&2
    exit 1
fi

apt update && apt upgrade -y

# if file [/var/run/reboot-required] exist then print error message to standard error.
if [ -f /var/run/reboot-required ]; then
    echo "A reboot is required in order to proceed with the install." >&2
    echo "Please reboot and re-run this script to finish the install." >&2
    exit 1
fi

echo "###############################################################################"
echo "Install linux-tools-virtual-hwe-20.04 "
echo "###############################################################################"
# Install hv_kvp utils
apt install -y linux-tools-virtual-hwe-20.04
apt install -y linux-cloud-tools-virtual-hwe-20.04

echo "###############################################################################"
echo "Install the xrdp service so we have the auto start behavior "
echo "###############################################################################"
apt install -y xrdp

echo "###############################################################################"
echo "Stop xrdp service "
echo "###############################################################################"
systemctl stop xrdp
systemctl stop xrdp-sesman

echo "###############################################################################"
echo "# Modify policy to let administrator users can work with GUI when connect with xrdp. "
echo "###############################################################################"

# change [org.gnome.controlcenter.user-accounts.policy] 
# let tag [<allow_any>] from "no" to "auth_admin_keep"
sed -i.bak -e 's/<allow_any>no<\/allow_any>/<allow_any>auth_admin_keep<\/allow_any>/' /usr/share/polkit-1/actions/org.gnome.controlcenter.user-accounts.policy

# change [org.gnome.controlcenter.datetime.policy]
# let tag [<allow_any>] from "no" to "auth_admin_keep"
sed -i.bak -e 's/<allow_any>no<\/allow_any>/<allow_any>auth_admin_keep<\/allow_any>/' /usr/share/polkit-1/actions/org.gnome.controlcenter.datetime.policy

# change [org.gnome.controlcenter.remote-login-helper.policy]
# let tag [<allow_any>] from "no" to "auth_admin_keep"
sed -i.bak -e 's/<allow_any>no<\/allow_any>/<allow_any>auth_admin_keep<\/allow_any>/' /usr/share/polkit-1/actions/org.gnome.controlcenter.remote-login-helper.policy

echo "###############################################################################"
echo "Change system timezone to Asia/Taipei "
echo "###############################################################################"
timedatectl set-timezone Asia/Taipei

echo "###############################################################################"
echo "Installing Tweak Tool "
echo "###############################################################################"
add-apt-repository universe
apt install -y gnome-tweak-tool

echo "###############################################################################"
echo "Setting Firewall "
echo "###############################################################################"
ufw default allow outgoing
ufw default deny incoming
ufw allow from 192.168.0.0/16 to any port 3389   # Allow local network connect with xrdp 
ufw allow from any to any port 80    # Allow connect to web server from anywhere
ufw allow from any to any port 443   # Allow connect to ssl web server from anywhere
ufw allow from 192.168.0.0/16 to any port 3306   # Allow local network connect to MySQL Server 
ufw enable    # Start Firewall

echo "###############################################################################"
echo "Installing tasksel "
echo "###############################################################################"
apt install -y tasksel

echo "###############################################################################"
echo "Installing LAMP Server "
echo "###############################################################################"
tasksel install lamp-server

echo "###############################################################################"
echo "Install is complete."
echo "Reboot your machine to begin using XRDP. "
echo "###############################################################################"
