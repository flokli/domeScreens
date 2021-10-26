#!/bin/bash

# sh mqtt-publist.sh TOPIC MESSAGE.

mosquitto_pub -h $(cat secretfile.txt) -t $1 -m $2



