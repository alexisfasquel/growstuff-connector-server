#!/bin/sh

# This script allow to constantly check the connexion
# When not connected, we create an Adhoc network
# This network is used to configure the wifi network
# A blinking led script is used to inform of the current state.
# The blinking script (blink.sh) is supposed to be in the same folder

# WARNING: Do not work with WEP encription yet
# UPDATE : WEP seems to be accepted by wpa supplicant 


createAdHocNetwork() {
	echo "Creating Ad-Hoc Network"
	pkill wpa_supplicant	#killing wpa_supplicant to avoid disconnection
	#Setting up Ad-Hoc networks
	iwconfig wlan0 mode Ad-Hoc essid GrowStuff key off
	ifconfig wlan0 192.168.0.1 broadcast 192.168.0.255 netmask 255.255.255.0
	service isc-dhcp-server start		#starting the dhcp server
	echo "Network GrowStuff created"
}


connectToWifi() {
	if [ ! -f /etc/wpa_supplicant/wpa_supplicant.conf ]; then
		return 0
	else 
		echo "Connecting to wifi..."
		service isc-dhcp-server stop	#Stoping the dhcp server
		pkill wpa_supplicant		#killing wpa_supplicant process before to start a new one
		wpa_supplicant -B -i wlan0 -c "`dirname $0`/wpa_supplicant.conf" 2> /dev/null
		sleep 1
		dhclient wlan0 -r		#Stoping the dhcp client and restarting
		dhclient wlan0 &
		for i in  1 2 3 4 5
		do
			sleep 3
			isConnected 2> /dev/null
			if [ $? -eq 1 ]; then
				echo "Success to connnect !"
				return 1
			fi
		done
		echo "ERROR : Connexion failed !"
		return 0
	fi
}

isConnected() {
	count=$(ping -c 1 www.google.com | awk -F, '/received/{print $2*1}')	#Trying to ping google
	if [ "$count" != "1" ] ; then
		return 0
	else
		return 1
	fi
}

if [ $(whoami) != "root" ]; then
	echo "You need root privileges to run this script"
else
	while [ 1 ]
	do
		eval "`dirname $0`/blink.sh blinkfast"
		connectToWifi
		if [ $? -eq 0 ]; then 		#If not connected then setting up Ad-Hoc  and waiting
			eval "`dirname $0`/blink.sh blink"
			createAdHocNetwork
			sleep 30
			echo "Trying to reconnect..."	
		else				#In the other case, watching for connection state change
			eval "`dirname $0`/blink.sh on"
			ok=true
			while [ $ok ]
			do
				sleep 10
				isConnected 2> /dev/null
				if [ $? -eq 1 ]; then
					echo "Connection status : ONLINE"
				else
					echo "Connection status : OFFLINE"
					echo "Trying to reconnect..."
					ok=false
				fi
			done
		fi
	done
fi
