#!/bin/sh


test() {
	while [ 1 ]
		do
		echo 0 > /sys/class/gpio/gpio11/value
		sleep 1
		echo 1 > /sys/class/gpio/gpio11/value
		sleep 1
	done
}

on() {
	echo 0 > /sys/class/gpio/gpio11/value
	if [ "$(pgrep blink)" != " " ]; then
		pkill blink & > /dev/null
	fi
}

#Definitly not perfect, but works well with just one blink process running
off() {
	echo 1 > /sys/class/gpio/gpio11/value	
	if [ "$(pgrep blink)" != " " ]; then
		pkill blink & > /dev/null
	fi
}

config() {
	echo 11 > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio11/direction
}

if [ ! -f /sys/class/gpio/gpio11/direction ]; then 
	config
fi

if  [ "$1" = "on" ]; then
	#echo "on"
	on
elif [ "$1" = "off" ]; then
	#echo "off"
	off
elif [ "$1" = "blink" ]; then
	#echo "blinking"
	test & > /dev/null
fi

