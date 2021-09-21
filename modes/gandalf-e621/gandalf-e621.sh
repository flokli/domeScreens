#!/bin/bash

mplayer -fs -loop 0 ../videos/gandal.mp4 & 
for ((;;))
do
	timeout 5 feh -xZF $(curl -A "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0" https://e621.net/posts/$(shuf -i 1-2891699 -n 1) | grep -Eo "data-large-file-url=\"https://static1.e621.net/data/(sample/)?[[:alnum:]]*/[[:alnum:]]*/[[:alnum:]]+\...." | grep -Eo "https://.*\....")
done
