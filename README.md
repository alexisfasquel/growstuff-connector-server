# Usage


# Setting up the general config of the differents interfaces

We're editing the interfaces config files :

sudo nano /etc/network/interfaces

To put the following configuration :




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
        fixed-address 10.0.0.100;
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

* Do not try to reconnect if there is someone connected to the ad-hoc network
* Deployment script
* Handeling WEP encryption and unprotected wifi ?
* Using crontab ?
