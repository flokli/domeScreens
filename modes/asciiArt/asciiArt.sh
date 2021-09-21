#!/bin/bash

while true
do

 timeout 10 termsaver urlfetcher -u https://www.pillowfort.social/Braeburned; clear; # Slowly print HTML content
 timeout 10 curl parrot.live; clear; # Cool parrot
 timeout 10 termsaver matrix; clear; 
 cat ./television.txt; sleep 5;  clear;
 timeout 20 termsaver rfc; clear;  # Print random RFC
 timeout 10 termsaver clock; clear;

done
