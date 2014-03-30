#!/bin/sh


blink() {
	if [ $(pgrep blink | wc -l) -gt 2 ]; then
		kill `pgrep blink | head -1`	#If already blinking then killing it
	fi
	while [ 1 ]
	do
		echo 0 > /sys/class/gpio/gpio11/value
		sleep $1
		echo 1 > /sys/class/gpio/gpio11/value
		sleep $1
	done
}

on() {
	echo 0 > /sys/class/gpio/gpio11/value
	pkill blink > /dev/null		# In any case, killing everyone
}

#Definitly not perfect, but works well with just one blink process running
off() {
	echo 1 > /sys/class/gpio/gpio11/value
	pkill blink > /dev/null		# In any case, killing everyone

}

config() {
	echo 11 > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio11/direction
}

if [ ! -d /sys/class/gpio/gpio11 ]; then
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
	blink 1 & > /dev/null
elif [ "$1" = "blinkfast" ]; then
	#echo "blinking"
	blink 0.2 & > /dev/null
fi


