#!/bin/sh

echo "`pwd`"

# Dowloading the init branch and unziping
wget -N https://github.com/alexisfasquel/growstuff-connector-server/archive/init-script.zip
unzip init-script.zip
rm init-script.zip 2>/dev/null

# Extracting the res folder
rm -R growstuff-connector-server-init-script 2>/dev/null
mv -f growstuff-connector-server-init-script/res ./res
rm -R growstuff-connector-server-init-script 2>/dev/null

# Updating intefaces configurations
mv -f ./res/interfaces /etc/network/interfaces

# Removing the automatic run of wpa_supplicant
rm /usr/share/dbus-1/system-services/fi.w1.wpa_supplicant1.service 2>/dev/null

# Installing dhcp server
apt-get install isc-dhcp-server

# Changing the init script
mv -f  ./res/isc-dhcp-server /etc/default/isc-dhcp-server

# Changing the mac adress on the dhcp conf file
address="`cat /sys/class/net/wlan0/address`"
sed -i "s/xx:xx:xx:xx:xx/$address/" res/dhcpd.conf

# Preventing the dhcp server from stating when booting
update-rc.d -f isc-dhcp-server remove

# Launching the deamon at startup
mv -f ./res/rc.local /etc/rc.local

# Getting the "server side" scripts and moving it 
wget https://github.com/alexisfasquel/growstuff-connector-server/archive/master.zip
unzip master.zip
rm master.zip 2>/dev/null
rm - R /home/pi/network 2>/dev/null
mv -f growstuff-connector-server-master /home/pi/network
rm -R res 2>/dev/null
