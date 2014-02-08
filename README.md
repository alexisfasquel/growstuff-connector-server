# Usage


# Setting up the general config of the differents interfaces

We're editing the interfaces config files :

    sudo nano /etc/network/interfaces

To put the following configuration :

    #start interfaces upon start of the system
    auto lo wlan0
    # register loopback interface
    iface lo inet loopback

    # use dhcp and allow interface to be started when kernel detects a hotplug event
    allow-hotplug eth0
    iface eth0 inet dhcp
 
    # use manual ip configuration for wlan0 interface and allow hotplug as well
    allow-hotplug wlan0
    iface wlan0 inet manual
    wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf
    
    #Setting up default with dhcp
    iface default inet dhcp
    

##Remove the automatic run of wpa_supplicant :

    sudo rm /usr/share/dbus-1/system-services/fi.w1.wpa_supplicant1.service

Warning : you may need to also remove (**not necessarly**) :
    
    sudo rm /usr/share/dbus-1/system-services/fi.epitest.hostap.WPASupplicant.service

#Installing the dchp server

    sudo apt-get update
    sudo apt-get install isc-dhcp-server

#Configuring the dchcp server

We need to edit the init script...

    sudo nano /etc/default/isc-dhcp-server
    
...to put the right interface :

    INTERFACES="wlan0"
   
Then we remove and create a new config file for the server...

    rm -f /etc/dhcp/dhcpd.conf
    sudo nano /etc/dhcp/dhcpd.conf

... with the following configuration :

    default-lease-time 600;
    max-lease-time 7200;
    
    subnet 192.168.0.0 netmask 255.255.255.0 {
      range 192.168.0.10 192.168.0.20;
      option routers 192.168.0.1;
      option broadcast-address 192.168.0.255;
    }
    
    host rpi {
        hardware ethernet xx:xx:xx::xx:xx;
        fixed-address 192.168.0.1;
    }

Of course `xx:xx:xx:xx:xx` represents the mac adress of the Raspberry pi.

# Preventing the dhcp server from stating when booting

    sudo update-rc.d -f isc-dhcp-server remove

# Running the script when booting

     sudo nano /etc/rc.local
 
 Adding the following snippet juste before the **exit 0**
     
     cd /home/pi/networks
     rm -f ynetworks.log
     sudo ./networks.sh &> networks.log &
     
**Issue zith the verbose...**
     
     
# ROADMAP

tail -f /var/log/syslog

* Do not try to reconnect if there is someone connected to the ad-hoc network
* Deployment script
* Handeling WEP encryption and unprotected wifi ?
* Using crontab ?
* make it a service
