#!/bin/bash

# Display help message
Help(){
  echo "This script requests posts from e621 or e926 related to a tag"
  echo "Requirements to run script: curl, jq"
  echo
  echo "Syntax: ./e621API.sh [-t|l|u|h]"
  echo "Options:"
  echo "  -t, --tag          Requested tag."
  echo "  -l, --limit        Limit of posts to fetch."
  echo "  -s, --safemode     Select Safemode, default is SFW." 
  echo "                       Options are NSFW, SFW, unsafe, safe, false and true."
  echo "  -h, --help         Print this help message"
  echo 
  echo
}

# If no arguments where given as input, print help message
if [ $# -eq 0 ]; then 
  Help
  echo "Error: No arguments given"
  exit 1
fi

# Set variables
Tag="comfy"
Limit=1
Safemode="true"

# Read argument input
# Due to limitaions for getopts and OPTARG, long flags are not possible 
#   and another solution have been implemented, 
# Help from https://www.redhat.com/sysadmin/arguments-options-bash-scripts and https://linuxhandbook.com/bash-case-statement/
while [[ "${1}" != "" ]]; do
  case ${1} in
  -t | --tag) Tag=${2};;
  -l | --limit) Limit=${2};;
  -s | --safemode)
    case ${2} in
      NSFW) Safemode="false";;
      unsafe) Safemode="false";;
      false) Safemode="false";;
      SFW) Safemode="true";;
      safe) Safemode="true";;
      true) Safemode="true";;
      "") Safemode="true";;
      *) Safemode="true";;
    esac;;
  -h | --help) # Display help
    Help
    #echo "Help message"
    exit;;
  \?) # Invalid option
    echo "Error: Invalid option"
    exit;;
  *) # Default case, display help
    Help
    #echo "Default case"
    exit;;
  esac
  shift 2
done

echo "tag: $Tag"
echo "limit: $Limit"
echo "Safemode: $Safemode"

if [ $Safemode == "false" ]; then
  Website=e621 #NSFW
else
  Website=e926 #SFW
fi

echo "Website: $Website"

feh --auto-zoom --fullscreen --quiet --hide-pointer --slideshow-delay 1 $(curl -A "domeScripts/1.0 (by Chad42Lion)" -H "Accept: application/json" "https://$Website.net/posts.json?tags=$Tag&limit=$Limit" | jq -r '.posts[].file.url')
