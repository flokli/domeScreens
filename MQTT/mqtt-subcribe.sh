#!/bin/bash

MQTTBroker=$(cat ../../secretFile.txt | head -1 | tail -1)

# if argument given, subscribe to topic 
# e.g.  sh mqtt-subscribe.sh /home    = subscribe to /home. else subcribe to /
if [ ! -z $1 ]; then
	mosquitto_sub -h $MQTTBroker -v -t "$1"
	echo "subscribing to topic: $1"
else
	mosquitto_sub -h $MQTTBroker -v -t /#
	echo "subscribing to topic: /"
fi
