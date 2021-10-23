#!/bin/bash

#argument 1, string: tag
#argument 2, int: limit search results to int
#argument 3, string: unsafe

if [ $3 == 'unsafe' ] 
then
  arg3=e621 #NSFW
else
  arg3=e926 #SFW
fi

echo $3; echo $arg3
# requires: curl, jq
#curl -A "domeScripts/1.0 (by Chad42Lion)" -H "Accept: application/json" "https://e926.net/posts.json?tags=bed&limit=1" | tr ',' '\n' | grep '"url":' | sed 's/"url":"//g' | sed 's/"}//g' | awk 'NR==1 {print; exit}'; 
#curl -A "domeScripts/1.0 (by Chad42Lion)" -H "Accept: application/json" "https://e926.net/posts.json?tags=bed&limit=1" | jq -r '.posts[0].file.url'

#curl -A "domeScripts/1.0 (by Chad42Lion)" -H "Accept: application/json" "https://e926.net/posts.json?tags=bed&limit=10" | jq -r '.posts['$(seq 9 | shuf | head -n 1)'].file.url'
#curl -A "domeScripts/1.0 (by Chad42Lion)" -H "Accept: application/json" "https://e926.net/posts.json?tags=$1&limit=$2" | jq -r '.posts['$(seq $2 | shuf | head -n 1)'].file.url'

feh --auto-zoom --fullscreen --quiet --hide-pointer --slideshow-delay 1 $(curl -A "domeScripts/1.0 (by Chad42Lion)" -H "Accept: application/json" "https://$arg3.net/posts.json?tags=$1&limit=$2" | jq -r '.posts[].file.url'
)

