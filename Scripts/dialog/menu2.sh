#!/bin/bash

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=7
BACKTITLE="Menu Options"
TITLE="Select a choice"
MENU="Choose one of the following options:"

OPTIONS=(1 "Set Rip and Run Address" \ 
	2 "Set CE-1D Address"  \
	3 "Show current Rip and Run Address" \ 
	4 "Show current CE-1D Address"  \
	5 "Show MAC Address" "Bash Shell")

CHOICE=$(dialog --clear \
		--backtitle "$BACKTITLE" \
		--title "$TITLE" \
		--menu "$MENU" \
		$HEIGHT $WIDTH $CHOICE_HEIGHT \
		"${OPTIONS[@]}" \
		2>&1 >/dev/tty)
print $choice
# clear
case $CHOICE in
	1)
	if (whiptail --title "Rip and Run" --yesno "Do you want to set the Rip and Run IP Address?" 10 60) then
   	RIPIP=$(whiptail --title "Rip and Run" --inputbox "What is the Rip and Run IP Address?" 10 60 192.168.1.10 3>&1 1>&2 2>&3)
    	exitstatus=$?
    	if [ $exitstatus = 0 ]; then
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
		;;
	2)
	if (whiptail --title "Radio Interface" --yesno "Do you want to set the Radio (CE-1D) IP Address?" 10 60) then
    	CE1DIP=$(whiptail --title "Rip and Run" --inputbox "What is the Radio (CE1D) IP Address?" 10 60 192.168.1.35 3>&1 1>&2 2>&3)
    	exitstatus=$?
    	if [ $exitstatus = 0 ]; then
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
		;;
	3)
	rrfile=$(</home/pi/rr-ip.ini)
	destdir1=/home/pi/rr-ip.ini
	whiptail --title "$destdir1" --msgbox "$rrfile" 10 60
		;;
	4)
	ce1dfile=$(</home/pi/ce1d-ip.ini)
	destdir2=/home/pi/ce1d-ip.ini
	whiptail --title "$destdir2" --msgbox "$ce1dfile" 10 60
		;;
	5)
		echo "Not implemented yet"
		;;
	6)
		/bin/bash
		;;
esac
