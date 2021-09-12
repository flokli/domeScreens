#!/bin/bash

while true
do

cat ascii-art.txt
sleep 10

 timeout 10 termsaver urlfetcher -u https://www.pillowfort.social/Braeburned
# timeout 20 termsaver starwars
 timeout 10 curl parrot.live

done
