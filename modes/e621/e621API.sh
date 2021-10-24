#!/bin/bash

# Display help message
Help(){
  echo "This script requests posts from e621 or e926 related to a tag"
  echo "Requirements to run script: curl, jq"
  echo
  echo "Syntax: ./e621API.sh [-t|l|u|h]"
  echo "Options:"
  echo "  -t, --tag             Requested tag."
  echo "  -l, --limit           Limit of posts to fetch."
  echo "  -s, --safemode        Select Safemode, default is SFW. Options are" 
  echo "                          NSFW, SFW, unsafe, safe, false or true."
  echo "  --slideshow-delay     Time between each image. Default is 1"
  echo "  -h, --help            Print this help message"
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
Limit=50
Safemode=true
SlideshowDelay=1

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
      NSFW) Safemode=false;;
      unsafe) Safemode=false;;
      false) Safemode=false;;
      SFW) Safemode=true;;
      safe) Safemode=true;;
      true) Safemode=true;;
      "") Safemode=true;;
      *) Safemode=true;;
    esac;;
  --slideshow-delay) SlideshowDelay=${2};; # feh argument
  -h | --help) # Display help
    Help
    exit;;
  \?) # Invalid option
    echo "Error: Invalid option"
    exit;;
  *) # Default case, display help
    Help
    exit;;
  esac
  shift 2
done

if [ $Safemode == false ]; then
  Website=e621 #NSFW
else
  Website=e926 #SFW
fi

showInputArgumentResults() {
  echo "Tag: $Tag"
  echo "Limit: $Limit"
  echo "Safemode: $Safemode"
  echo "Website: $Website"
  echo "Slideshow-delay: $SlideshowDelay"
}

displayImage(){
  # The official e621 API is used: https://e621.net/help/api
  # e621/e926 have one requriement: use a custom user-agent that includes 
  #     your project name and username
  # There is a rate limit of two requests per second
  callAPI=$(curl -s -A "domeScripts/1.0 (by Chad42Lion)" -H "Accept: application/json" "https://$Website.net/posts.json?tags=$Tag&limit=$Limit" | jq -r '.posts[].file.url')

  # --reload=0 option disables reloading of images located on disk, and is included
  # since the warning "feh WARNING: inotify_add_watch failed: No such file or directory"
  # occurs
  feh --auto-zoom --fullscreen --hide-pointer --reload=0 --slideshow-delay $SlideshowDelay $callAPI
}

showInputArgumentResults
displayImage