#!/bin/bash
# Usage: ./mqtt-publist.sh -t TOPIC -m "MESSAGE"

MQTTBroker=$(cat ../../secreFile.txt | head -1 | tail -1)



# Remove {} surounding $3
if [ "$3" == { ]; then
  argumentInput=${3:1}
elif [ "$3" == } ]; then
  argumentInput=$(echo $3 | rev |  cut -c 2- | rev)
else 
  argumentInput=$3
fi

echo $argumentInput

# Publish to topic and send message
mosquitto_pub -h $MQTTBroker -t $1 -m "$argumentInput"