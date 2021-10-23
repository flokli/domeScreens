#!/bin/bash

curl -A "domeScripts/1.0 (by Chad42Lion)" -H "Accept: application/json" "https://e926.net/posts.json?tags=bed&limit=1" | tr ',' '\n' | grep '"url":' | sed 's/"url":"//g' | sed 's/"}//g' | awk 'NR==1 {print; exit}'; 