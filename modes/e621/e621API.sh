#!/bin/bash

# Display help message
Help(){
  echo "This script requests posts from e621 or e926 related to a tag"
  echo "Requirements to run script: curl, jq"
  echo
  echo "Syntax: ./e621API.sh [-t|l|u|h]"
  echo "Options:"
  echo "  -t, --tag             Requested tag."
  echo "  -l, --limit           Limit of posts to fetch. Default is 50"
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

# Default variables
Tag="comfy"
Limit=50
Safemode=true
SlideshowDelay=1

# Split single string argument with space as a delimiter
# https://alltodev.com/how-do-i-split-a-string-on-a-delimiter-in-bash
splitByDelimiter() {
  arguments=$@
  IFS=" " # Delimiter
  read -ra ADDR <<< "$arguments"
  argv=""
  
  for i in "${ADDR[@]}"; do
    echo "Current i: ${i}"
    case ${argv} in 
      -t | --tag) Tag=${i};;
      -l | --limit) Limit=${i};;
      -s | --safemode)
        case ${i} in
          NSFW | unsafe | false) Safemode=false;;
          SFW | safe | true) Safemode=true;;
          "") Safemode=true;;
          *) Safemode=true;;
        esac;; 
      --slideshow-delay) SlideshowDelay=${i};; # feh argument
      \?) echo "Error: Invalid option" exit;;
      #*) echo "Error: default case2"; exit;;
    esac
    argv=${i}
  done
  unset IFS
  echo "Tag: $Tag"
  echo "Limit: $Limit"
  echo "Safemode: $Safemode"
}

# Read argument input
# Due to limitaions for getopts and OPTARG, long flags are not possible 
#   and another solution have been implemented, 
# Help from https://www.redhat.com/sysadmin/arguments-options-bash-scripts and https://linuxhandbook.com/bash-case-statement/
while [[ "${1}" != "" ]]; do
  case ${1} in
  -t | --tag) Tag=${2};;
  -l | --limit) Limit=${2};;

  -s | --safemode)
    case ${2} in # Safemode: choose second argument
      NSFW | unsafe | false) Safemode=false;;
      SFW | safe | true) Safemode=true;;
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
    splitByDelimiter ${1} # If argument is one string, split it up
    echo
    echo "Tag: $Tag"
    echo "Limit: $Limit"
    echo "Safemode: $Safemode"
    echo "Argument before shift: ${1}"
    shift 1
    echo "Argument after shift: ${1}"
    ;;
    #echo "Default case" 
    #Help
    #exit;;
  esac
  shift 2 # Shift arguments left 2 times, i.e. remove processed arguments
done

if [ $Safemode == false ]; then
  Website=e621 #NSFW
else
  Website=e926 #SFW
fi

showInputArgumentResults() {
  echo
  echo "Parsed arguments:"
  echo "Tag: $Tag"
  echo "Limit: $Limit"
  echo "Safemode: $Safemode"
  echo "Website: $Website"
  echo "Slideshow-delay: $SlideshowDelay"
  echo
}

displayImage(){
  # The official e621 API is used: https://e621.net/help/api
  # e621/e926 have one requriement: use a custom user-agent that includes 
  #     your project name and username
  # There is a rate limit of two requests per second
  callAPI=$(curl -s -A "domeScripts/1.0 (by Chad42Lion)" -H "Accept: application/json" "https://$Website.net/posts.json?tags=$Tag&limit=$Limit" | jq -r '.posts[].file.url')
  echo $callAPI 
  # > callAPI2.txt
  # --reload=0 option disables reloading of images located on disk, and is included
  # since the warning "feh WARNING: inotify_add_watch failed: No such file or directory"
  # occurs
  feh --auto-zoom --fullscreen --hide-pointer --reload=0 --slideshow-delay $SlideshowDelay $callAPI
}

showInputArgumentResults
displayImage
