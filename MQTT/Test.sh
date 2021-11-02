#!/bin/bash

# Open from MQTT folder for now
MQTTBroker=$(cat ../secreFile.txt | head -1 | tail -1)
mosquitto_sub -h $MQTTBroker -t /bornhack/dome | xargs -I %output% ./handleMessage.sh %output%
