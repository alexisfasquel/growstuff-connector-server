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
    

#Hande WPA_SUPPLICANT
##Remove the automatic run of wpa_supplicant :

    sudo rm /usr/share/dbus-1/system-services/fi.w1.wpa_supplicant1.service

Warning : you may need to also remove (**not necessarly**) :
    
    sudo rm /usr/share/dbus-1/system-services/fi.epitest.hostap.WPASupplicant.service

###The wpa_supplicant.conf file is located by default here : `/etc/wpa_supplicant/wpa_supplicant.conf`
Because of privileges issues, this config files has been moved un the same directory as the scripts


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
        hardware ethernet xx:xx:xx:xx:xx;
        fixed-address 192.168.0.1;
    }

Of course `xx:xx:xx:xx:xx` represents the mac adress of the Raspberry pi.

# Preventing the dhcp server from stating when booting

    sudo update-rc.d -f isc-dhcp-server remove

# Running the script at startup

     sudo nano /etc/rc.local
 
 Adding the following snippet juste before the **exit 0**
     
     cd $HOME/networks
     sudo ./networks.sh > networks.log 2>&1 &
     
# ROADMAP

* Deployment script
* Handeling WEP encryption and unprotected wifi ?
* Using crontab ?
* Make it a service 

### Using the init script

So, what do you do with this deployement script ?
Just one line :

    wget https://raw.githubusercontent.com/alexisfasquel/growstuff-connector-server/init/init.sh -O - | sudo sh
