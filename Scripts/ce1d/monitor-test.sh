# nc -l 3000 | /home/pi/Scripts/ce1d/ce1d.py 
unset incoming
unset incoming2
unset incoming3
unset incidentDPA
unset incidentNum
unset incidentName
incoming=$(cat /home/pi/Temp/vc0003.cap)
incoming2=$(echo "$incoming" | sed ':a;N;$!ba;s/\r/ /g')
curTime=$(date +"%D %T")
incidentDPA=$(echo "$incoming2" | awk -v FS="(DPA: |Incident Number:     )" '{print $2}' | tr -d "\n")
# echo "$incidentDPA"
incidentNum=$(echo "$incoming2" | awk -v FS="(Incident #:     |     Incident Name:   )" '{print $2}' | tr -d "\n")
# echo "$incidentNum"
incidentName=$(echo "$incoming2" | awk -v FS="(     Incident Name:   |\r\r\n)" '{print $2}' | tr -d "\n")
incidentTime=$(echo "$incoming2" | awk -v FS="(Time:       [0-9][0-9]-[a-zA-Z][a-z][a-z]-[0-9][0-9][0-9][0-9]\/|\r\r\n)" '{print $2}' | tr -d "\n")
unconvDate=$(date +"%X")
echo -e "unconvDate $unconvDate"
convDate=$(date +"%X" | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
convTime=$(echo "$incidentTime" | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
convDif=$(echo $(( convDate - convTime)))
# echo -e "DPA: $incidentDPA Number: $incidentNum Name: $incidentName\n"
# echo -e "curTime $curTime"
if [[ "$convDif" -gt 0 && "$convDif" -lt 240 ]]
then echo -e "Alarm Triggered - $convdif" 
else echo -e "Too Old - $convDif"
fi
echo -e "incidentTime $incidentTime"
echo -e "convDate $convDate"
echo -e "convTime $convTime"
echo -e "Difference $convDif"
