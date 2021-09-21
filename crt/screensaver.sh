#!/bin/bash

while true
do

cat ascii-art.txt; sleep 10; clear;

 timeout 10 termsaver urlfetcher -u https://www.pillowfort.social/Braeburned; clear;
 timeout 10 ffplay ../videos/gandalf_crt.mp4
 timeout 10 curl parrot.live; clear;
 cat ./BH.txt; sleep 5;  clear;
 cat ./21.txt;  sleep 5; clear;

done
