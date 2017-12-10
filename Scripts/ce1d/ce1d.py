#! /usr/bin/python
# button mac: 68:54:fd:f6:a0:20

import os
import random
import httplib, urllib
import urllib2
#from ce1d-ip.py
# source /home/pi/Scripts/ce1d/duplicator.cfg
# urllib2.urlopen("http://192.168.133.35:8080/state.xml?relayState=2&pulseTime=25").read()
import ConfigParser
config = ConfigParser.ConfigParser()
config.read("/home/pi/ce1d-ip.ini")
relayip = config.get("ip", "ce1dip")
ip = "http://%s:8080/state.xml?relayState=2&pulseTime=5" % relayip
# conn = httplib.HTTPSConnection("api.pushover.net:443")
# conn.request("POST", "/1/messages.json", 
# urllib.urlencode({ 
#"token": "a98hhVBULCrTmjKQ2hAgbx4V4z4hSe", 
#"user": "ubYLUfY1QTXwKVBLoNikXKgYTfqdZe", 
#"message": "Now Opening: %s" % ip,
#}), { "Content-type": "application/x-www-form-urlencoded" })
#conn.getresponse()
print ip
urllib2.urlopen(ip).read()
