#!/bin/bash
# Open from MQTT folder for now

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
mosquitto_sub -h $MQTTBroker -t /bornhack/dome | xargs -I %output% ./handleMessage.sh %output%
