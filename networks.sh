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
	iwconfig wlan0 mode Ad-Hoc essid GrowStuff key off
	ifconfig wlan0 192.168.0.1 broadcast 192.168.0.255 netmask 255.255.255.0
	service isc-dhcp-server start
	echo "Network GrowStuff created"
}


connectToWifi() {
	echo "Connecting to wifi..."
	pkill wpa_supplicant
	wpa_supplicant -B -iwlan0 -cwpa_supplicant.conf & > /dev/null 2>&1
	dhclient wlan0
}

if [ $(whoami) != "root" ]; then
	echo "You need root privileges to run this script"
else
	

	#if there is an ssid and a key in params then we want to uptade the wifi crendentials
	if [ "$1" != "" ] && [ "$2" != "" ]; then
		echo "Setting up the new configuration"
		wpa_passphrase $1 $2 > wpa_supplicant.conf		#updating the wpa conf file with the new network credentials
		cat wpa_supplicant.conf		#Displaying the new config

		connectToWifi
		exit 0		#connecting and exiting, so that we leave the main deamon do hisjob

	#if no config file then it is the first configuration
	elif [ ! -f  wpa_supplicant.conf ]; then 	#so we directly go for the ad-hoc network
		./blink.sh blink
		createAdHocNetwork
	#In the other case, we connect
	else
		./blink.sh on
		connectToWifi
	fi
	#then we watch for connection state change
	while [ 1 ]
	do
		sleep 30 #Waiting 30 seconds  before we check the connection state
		count=$(ping -c 1 www.google.com | awk -F, '/received/{print $2*1}')	#Trying to ping google
		if [ $count -ne 1 ] ; then	# If failed setting up ad-hoc
			./blink blink
			echo "Connection status : OFFLINE"
			createAdHocNetwork
			sleep 120	# Waiting two minutes before retrying the connection
			connectToWifi
		else
			./blink.sh on
			echo "Connection status : OK"
		fi
			#ip=$(ifconfig wlan0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1 }')	#by getting the ip adress 
		done
fi  
