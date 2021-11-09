#!/bin/bash
# Usage: ./mqtt-publist.sh -t TOPIC -m "MESSAGE"
# usage: ./mqtt-publish.sh /bornhack/dome -m "iv --tag bed --limit 10 --safemode true"


echo "-----------------------------------------";
echo "Argument(s) given to broker: $@";
echo "Number of arguments: $#";
echo;

# Display help message
Help(){
  echo "MQTT handler to request different modes"
  echo
  echo 'Syntax: ./mqtt-publish.sh /some/topic -m "message"'
  echo '  Example: ./mqtt-publish.sh /test/topic -m "iv --tag bed --limit 10 --safemode true"'
  echo "Options:"
  echo "  gan, gandalf, --gandalf"
  echo "  uni, unicorn, --unicorn"
  echo "  sexgan, sexy-gandalf, --sexy-gandalf"
  echo "  iv, image-viewer, --image-viewer"
  echo "  aa, asciiArt"
  echo "  kill, --kill"
  echo "  -h, --help            Print this help message"
  echo 
}

# Check if zero, one or more arguments was given.
if [ $# -eq 0 ]; then
  Help; echo "Error: No arguments given"; exit 1
elif [[ ${@} == "" ]]; then
  Help; echo "Error: Empty argument"; exit 1
fi

# Get MQTT broker host from ../secretFile.txt
getMQTTBroker() {
  fetchBroker=$(cat ../secretFile.txt | head -1 | tail -1)
  IFS=':' # Delimiter
  read -ra ADDR <<< "$fetchBroker" # Split by delimiter
  unset IFS
  MQTTBroker=${ADDR[1]}
}

# Remove {} surounding $3
if [ "$3" == { ]; then
  argumentInput=${3:1}
elif [ "$3" == } ]; then
  argumentInput=$(echo $3 | rev |  cut -c 2- | rev)
else 
  argumentInput=$3
fi

getMQTTBroker
echo $argumentInput
echo "MQTT broker: $MQTTBroker"

# Publish to topic and send message
mosquitto_pub -h $MQTTBroker -t $1 -m "$argumentInput"
