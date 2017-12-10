# nc -l 3000 | /home/pi/Scripts/ce1d/ce1d.py 
socat -u tcp-l:3000,fork system:/home/pi/Scripts/ce1d/ce1d.py
