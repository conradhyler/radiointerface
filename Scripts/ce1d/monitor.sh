unset incoming
unset incoming2
unset incoming3
unset incidentDPA
unset incidentNum
unset incidentName
incoming=$(socat -u tcp-l:3000 STDIO)
incoming2=$(echo "$incoming" | sed ':a;N;$!ba;s/\r/ /g')
curTime=$(date +"%D %T")
incidentDPA=$(echo "$incoming2" | awk -v FS="(DPA: |Incident Number:     )" '{print $2}' | tr -d "\n")
# echo "$incidentDPA"
incidentNum=$(echo "$incoming2" | awk -v FS="(Incident #:     |     Incident Name:   )" '{print $2}' | tr -d "\n")
# echo "$incidentNum"
incidentName=$(echo "$incoming2" | awk -v FS="(     Incident Name:   |\r\r\n)" '{print $2}' | tr -d "\n")
incidentTime=$(echo "$incoming2" | awk -v FS="(Time:       [0-9][0-9]-[a-zA-Z][a-z][a-z]-[0-9][0-9][0-9][0-9]\/|\r\r\n)" '{print $2}' | tr -d "\n")
convDate=$(date +"%X" | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
convTime=$(echo "$incidentTime" | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
convDif=$(echo $(( convDate - convTime)))
echo -e "DPA: $incidentDPA Number: $incidentNum Name: $incidentName\n"
if [[ "$incoming2" =~ ^(.*(Description))(.*(Location))(.*(Response))(.*(Incident)).* ]]
then
# echo "Match"
# echo -e "$curTime -- Alarm Triggered -- DPA: $incidentDPA Number: $incidentNum"
echo -e "$curTime -- Alarm Triggered -- DPA: $incidentDPA Number: $incidentNum Name: $incidentName" >> /home/pi/match.log
if [[ $convDif -gt 0 -a -lt 240 ]]
then /usr/bin/python /home/pi/Scripts/ce1d/ce1d.py &
else echo -e "Too Old - $convDif"
fi
# echo "Alarms Triggered"
# echo "Done Sleeping"
else
# echo "No Match!"
# echo -e "$curTime -- No Match Found"
echo -e "$curTime -- No Match Found" >> /home/pi/match.log
fi
# echo "monitor.sh ending"
sudo /bin/bash /home/pi/Scripts/ce1d/monitor.sh &