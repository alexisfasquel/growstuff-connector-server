#!/bin/sh

# Dowloading the init branch and unziping
rm -R /tmp/growstuff-connector-server-init-script 2>/dev/null
wget https://github.com/alexisfasquel/growstuff-connector-server/archive/init-script.zip
unzip -d /tmp init-script.zip
rm init-script.zip 2>/dev/null

# Extracting the res folder
rm -R /tmp/res 2>/dev/null
mv -f /tmp/growstuff-connector-server-init-script/res /tmp/res
rm -R /tmp/growstuff-connector-server-init-script 2>/dev/null

# Updating intefaces configurations
mv -f /tmp/res/interfaces /etc/network/interfaces

# Removing the automatic run of wpa_supplicant
rm /usr/share/dbus-1/system-services/fi.w1.wpa_supplicant1.service 2>/dev/null

# Installing dhcp server
apt-get install isc-dhcp-server

# Changing the init script
mv -f  /tmp/res/isc-dhcp-server /etc/default/isc-dhcp-server

# Changing the mac adress on the dhcp conf file
address="`cat /sys/class/net/wlan0/address`"
sed -i "s/xx:xx:xx:xx:xx/$address/" /tmp/res/dhcpd.conf

# Changing the config
mv -f /tmp/res/dhcpd.conf /etc/dhcp/dhcpd.conf

# Preventing the dhcp server from stating when booting
update-rc.d -f isc-dhcp-server remove

# Launching the deamon at startup
mv -f /tmp/res/rc.local /etc/rc.local

# Getting the "server side" scripts and moving it
wget  https://github.com/alexisfasquel/growstuff-connector-server/archive/master.zip
rm -R /tmp/growstuff-connector-server-master 2>/dev/null
unzip -d /tmp  master.zip
rm master.zip 2>/dev/null
rm -R /home/pi/network 2>/dev/null
mv -f /tmp/growstuff-connector-server-master /home/pi/network
rm -R /tmp/res 2>/dev/null
