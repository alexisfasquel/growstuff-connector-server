#!/bin/sh

if [ $(whoami) != "root" ]; then
	echo "You need root privileges to run this script"
else
	
	#if there is an ssid and a key in params then we want to uptade the wifi crendentials
	if [ "$1" != "" ] && [ "$2" != "" ]; then
		echo "Setting up the new configuration"
		wpa_passphrase $1 $2 > /home/pi/networks/wpa_supplicant.conf		#updating the wpa conf file with the new network credentials
		cat /home/pi/networks/wpa_supplicant.conf		#Displaying the new config
		
		echo "Restarting networks daemon"
		pkill networks		
		/home/pi/networks/networks.sh &
	fi
fi

exit 0