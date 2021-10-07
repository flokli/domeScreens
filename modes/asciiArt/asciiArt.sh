#!/bin/bash

# Requirements:
#  - rfc
#  - lolcat
#  - termsaver

random_rfc(){
/usr/bin/ls -1 /usr/share/doc/rfc/txt/*.txt | grep -v rfc-index | shuf | head -1
}

slowType(){
 timeout --foreground $1 pv -L $2 -q
}
while sleep 0.2
do
 clear; 
 curl -s https://www.pillowfort.social/Braeburned | slowType 10 120; clear;
 timeout 10 curl parrot.live; clear; # Cool parrot
 curl -s https://covid19-cli.wareneutron.com/denmark | slowType 15 1000; sleep 5; clear; 
 timeout 10 termsaver matrix; clear; # Matrix
 cat ./television.txt; sleep 5;  clear; 
 slowType 20 75 < $(random_rfc); sleep 3; clear; # Random RFC
 timeout 10 termsaver clock; clear;
 cat as205235.txt | lolcat -f | slowType 20 5000; sleep 2; clear; # Print whois for AS205235
 curl -s wttr.in/Frederiksberg | slowType 15 1000; sleep 10; clear # Show weather
 timeout --foreground 10 curl -s https://hamkong.herokuapp.com/gifanime?g=cat; clear;
 cat $0 | lolcat -a --speed=30.0 --duration=8; sleep 2; clear;
 slowType 10 4500000 < hacker.txt; clear
 #timeout --foreground 20 curl -s https://asciitv.fr  
done
