#!/bin/bash

if [ ! -z $1 ]		# if argument given, subscribe to topic 
			# e.g.  sh mqtt-subscribe.sh /home    = subscribe to /home. else subcribe to /
then
	mosquitto_sub -h $(cat secretfile.txt) -v -t $1
else
	mosquitto_sub -h $(cat secretfile.txt) -v -t /#
fi
