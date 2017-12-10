#!/bin/bash
file="/home/pi/rr-ip.ini"
myip=$(hostname -I)
myip=${myip/ /}
read -d $'\x04' rrip < "$file"
duplicator -f $rrip:515 -d $myip:3000 -p 515
# duplicator -f 192.168.133.10:515 -d 192.168.133.122:3000 -p 515
