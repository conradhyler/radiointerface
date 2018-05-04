#!/bin/bash

# while-menu-dialog: a menu driven system information program

DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0

display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}

while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "System Information" \
    --title "Menu" \
    --clear \
    --cancel-label "Exit" \
    --menu "Please select:" $HEIGHT $WIDTH 6 \
    "1" "Set Rip and Run Address" \
    "2" "Set CE-1D Address" \
    "3" "Show current Rip and Run Address" \
	"4" "Show current CE-1D Address" \
	"5" "Bash Shell"
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      echo "Program terminated."
      exit
      ;;
    $DIALOG_ESC)
      clear
      echo "Program aborted." >&2
      exit 1
      ;;
  esac
  case $selection in
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
done
