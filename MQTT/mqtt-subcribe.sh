#!/bin/bash

# Get MQTT broker host from ../secretFile.txt
MQTTBroker=""
getMQTTBroker() {
  fetchBroker=$(cat ../secretFile.txt | head -1 | tail -1)
  IFS=':' # Delimiter
  read -ra ADDR <<< "$fetchBroker" # Split by delimiter
  unset IFS
  MQTTBroker=${ADDR[1]}
}

getMQTTBroker
echo "MQTT broker: $MQTTBroker"

# if argument given, subscribe to topic 
# e.g.  sh mqtt-subscribe.sh /home    = subscribe to /home. else subcribe to /
if [ ! -z $1 ]; then
	mosquitto_sub -h $MQTTBroker -v --topic "$1"
	echo "subscribing to topic: $1"
else
	mosquitto_sub -h $MQTTBroker -v --topic /#
	echo "subscribing to topic: /"
fi
