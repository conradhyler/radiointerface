# nc -l 3000 | /home/pi/Scripts/ce1d/ce1d.py 
unset incoming
unset incoming2
unset incoming3
unset incidentDPA
unset incidentNum
unset incidentName
incoming=$(socat -u tcp-l:3000 STDIO)
echo -e "--start--" >> /home/pi/print.log
echo -e "$incoming" >> /home/pi/print.log
echo -e "---end---" >> /home/pi/print.log
incoming2=$(echo "$incoming" | sed ':a;N;$!ba;s/\r/ /g')
curTime=$(date +"%D %T")
incidentDPA=$(echo "$incoming2" | awk -v FS="(DPA: |Incident Number:     )" '{print $2}' | tr -d "\n")
incidentNum=$(echo "$incoming2" | awk -v FS="(Incident #:     |     Incident Name:   )" '{print $2}' | tr -d "\n")
incidentName=$(echo "$incoming2" | awk -v FS="(     Incident Name:   |\r\r\n)" '{print $2}' | tr -d "\n")
incidentTime=$(echo "$incoming2" | awk -v FS="(Time:       [0-9][0-9]-[a-zA-Z][a-z][a-z]-[0-9][0-9][0-9][0-9]\/|\r\r\n)" '{print $2}' | tr -d "\n")
convDate=$(date +"%X" | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
convTime=$(echo "$incidentTime" | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
convDif=$(echo $(( convDate - convTime)))
echo -e "DPA: $incidentDPA Number: $incidentNum Name: $incidentName\n"
if [[ "$incoming2" =~ ^(.*(Description))(.*(Location))(.*(Response))(.*(Incident)).* ]]
then
	if [[ $convDif -gt -30 && $convDif -lt 240 ]]
	then 
		# if [[ "$incoming2" =~ (.*(Abort)).* ]]
		# then echo -e "$curTime -- Contained Abort -- DPA: $incidentDPA Number: $incidentNum Name: $incidentName Time: $incidentTime Diff: $convDif" >> /home/pi/match.log
		# else
		echo -e "$curTime -- Alarm Triggered -- DPA: $incidentDPA Number: $incidentNum Name: $incidentName Time: $incidentTime Diff: $convDif" >> /home/pi/match.log
		/usr/bin/python /home/pi/Scripts/ce1d/ce1d.py &
		# fi
	else echo -e "$curTime -- Time over 4 min -- DPA: $incidentDPA Number: $incidentNum Name: $incidentName Time: $incidentTime Diff: $convDif" >> /home/pi/match.log
	fi
# /usr/bin/python /home/pi/Scripts/ce1d/ce1d.py &
else
echo -e "$curTime -- No Match Found  --" >> /home/pi/match.log
fi
sudo /bin/bash /home/pi/Scripts/ce1d/monitor.sh &
