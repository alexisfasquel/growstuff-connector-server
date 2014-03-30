#!/bin/sh

# Dowloading the repo and unziping
rm -R /tmp/growstuff-connector-server-master 2>/dev/null
rm master.zip 2>/dev/null
wget https://github.com/alexisfasquel/growstuff-connector-server/archive/master.zip
unzip -d /tmp master.zip
rm master.zip 2>/dev/null

path="/tmp/growstuff-connector-server-master"

# Updating intefaces configurations
mv -f "$path/init/res/interfaces" /etc/network/interfaces

# Removing the automatic run of wpa_supplicant
rm /usr/share/dbus-1/system-services/fi.w1.wpa_supplicant1.service 2>/dev/null

# Installing dhcp server
apt-get install isc-dhcp-server

# Changing the init script
mv -f  "$path/init/res/isc-dhcp-server" /etc/default/isc-dhcp-server

# Changing the mac adress on the dhcp conf file
address="`cat /sys/class/net/wlan0/address`"
sed -i "s/xx:xx:xx:xx:xx/$address/" "$path/init/res/dhcpd.conf"

# Changing the config
mv -f "$path/init/res/dhcpd.conf" /etc/dhcp/dhcpd.conf

# Preventing the dhcp server from stating when booting
update-rc.d -f isc-dhcp-server remove

# Launching the deamon at startup
mv -f "$path/init/res/rc.local" /etc/rc.local

# Moving the network folder in the right place
rm -R /home/pi/network 2>/dev/null
mv -f "$path/network" /home/pi/network

# Cleaning the tmp folder
rm -R "$path" 2>/dev/null
