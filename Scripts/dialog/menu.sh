#!/bin/bash
clear
destdir1=/home/pi/rr-ip.ini
destdir2=/home/pi/ce1d-ip.ini
if (whiptail --title "Rip and Run" --yesno "Do you want to set the Rip and Run IP Address?" 10 60) then
    RIPIP=$(whiptail --title "Rip and Run" --inputbox "What is the Rip and Run IP Address?" 10 60 192.168.1.10 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
#    echo "You entered:" $RIPIP
	destdir1=/home/pi/rr-ip.ini
	if [ -f $destdir ]	
	then
		echo $RIPIP > $destdir1
        fi
	else
    echo "You chose Cancel."
fi
else
    echo "Rip and Run IP Address remains unchanged"
fi
if (whiptail --title "Radio Interface" --yesno "Do you want to set the Radio (CE-1D) IP Address?" 10 60) then
    CE1DIP=$(whiptail --title "Rip and Run" --inputbox "What is the Radio (CE1D) IP Address?" 10 60 192.168.1.35 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
#    echo "You entered:" $CE1DIP
	destdir2=/home/pi/ce1d-ip.ini
	if [ -f $destdir2 ]
	then
		CE1DIP2="[ip]\nce1dip: ${CE1DIP}"
		echo $CE1DIP2 > $destdir2
	fi
	 else
    echo "You chose Cancel."
fi
else
    echo "Radio (CE-1D) IP Address remains unchanged"
fi
echo "\nCurrent Configuration:"
echo "\nContents of $destdir1:"
cat $destdir1
echo "\nContents of $destdir2:"
cat $destdir2
echo "\n To rerun script, type: ./configure.sh"
# whiptail --title "$destdir1" --msgbox "$RIPIP" 10 60
# whiptail --title "$destdir2" --msgbox "$CE1DIP2" 10 60
