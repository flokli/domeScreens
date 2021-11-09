#!/bin/bash
# This program can take arguments and show images from e621, e926 and danbooru
#  related to a tag for the the images. Image viewing is using feh and
#  JSON given from the site are parsed by jq.
# The script have been developed with MQTT in mind and have an option
#  to split up a single argument into multiple arguments

echo "-----------------------------------------";
echo "Argument(s) given: $@";
echo "Number of arguments: $#";
echo;

# Display help message
Help(){
  echo "This script requests posts from e621 or e926 related to a tag"
  echo "Requirements to run script: curl, jq, feh"
  echo
  echo "Syntax: ./e621API.sh [-t|l|u|m|s|h]"
  echo "Options:"
  echo "  -t, --tag             Requested tag."
  echo "  -l, --limit           Limit of posts to fetch. Default is 50"
  echo "  -s, --safemode        Select Safemode, default is SFW. Options are" 
  echo "                          NSFW, SFW, unsafe, safe, false or true."
  echo "  -m, --mode            Select e621 or anime mode. Default e621"
  echo "  --slideshow-delay     Time between each image. Default is 1"
  echo "  -h, --help            Print this help message"
  echo 
}

# Default variables
Tag="comfy"
Limit=50
Safemode=true
SlideshowDelay=1
Mode="e621"
danbooruUser=""
danbooruPass=""
choosenAPI=""
Website=""

# Split single string argument with space as a delimiter.
# MQTT sends a single argument that needs to be splitted up
# https://alltodev.com/how-do-i-split-a-string-on-a-delimiter-in-bash
splitByDelimiter() {
  if [ $# -eq 0 ]; then 
    echo "Error: No arguments given to splitByDelimiter()"
    exit 1
  fi
  arguments=${@}
  echo "Arguments in splitByDelimiter: $arguments"; echo

  IFS=" " # Delimiter
  read -ra ADDR <<< "$arguments"
  
  processArguments ${ADDR[@]} # Parse output to 
  unset IFS
}

# Read argument input and shift when processed
# Due to limitaions for getopts and OPTARG, long flags are not possible 
#   and another solution have been implemented, 
# Help from https://www.redhat.com/sysadmin/arguments-options-bash-scripts and https://linuxhandbook.com/bash-case-statement/
processArguments() {
  while [[ "$@" != "" ]]; do
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

    --slideshow-delay) SlideshowDelay=${2};; # feh option

    -m | --mode) # Selects anime or furry mode. Default is furry
      case ${2} in # Select mode from tailing argument
        e621 | e926 | furry) Mode="e621";;
        anime | danbooru) Mode="danbooru";;
        "") Mode="e621";;
        *) Mode="e621";;
      esac;;

    -h | --help) # Display help
      Help
      exit;;

    \?) # Invalid option
      echo "Error: Invalid option"
      exit;;
    "") echo "Error: Empty argument in flag case"; exit;;
    *) # Default case, shift last argument(s)
      echo "Default case: "
      echo "  Tag: $Tag"
      echo "  Limit: $Limit"
      echo "  Safemode: $Safemode"
      echo "  Argument before shift: ${1}"
      shift 1
      echo "  Argument after shift: ${1}"
      echo;;
    esac
    shift 2 # Shift arguments left 2 times, i.e. remove processed arguments
  done
}

# Check if zero, one or more arguments was given.
if [ $# -eq 0 ]; then
  Help; echo "Error: No arguments given"; exit 1
elif [[ ${@} == "" ]]; then
  Help; echo "Error: Empty argument"; exit 1
# One argument from MQTT that needs to be spitted up before processing them
elif [ $# -eq 1 ]; then
  splitByDelimiter ${@};
# Process multiple arguments
else
  processArguments ${@};
fi

# Translate safemode to website
if [ $Safemode == false ]; then
  choosenSafemode=explicit #NSFW
else
  choosenSafemode=safe #SFW
fi

# Get Danbuuro username and password from secretFile
danbooruKeys() {
  danbooruUser=$(cat ../../secretFile.txt | head -2 | tail -1)
  danbooruPass=$(cat ../../secretFile.txt | head -3 | tail -1)

  IFS=':' # Delimiter
  read -ra ADDRUser <<< "$danbooruUser" # Split by delimiter
  read -ra ADDRPass <<< "$danbooruPass"
  
  echo "Danbooru user: ${ADDRUser[1]}"
  #echo ${ADDRPass[1]}

  unset IFS
}

# Choose which website to use for fetching images
chooseURL() {
  case ${1} in
    e621)
      # e621 API documentation: https://e621.net/help/api
      # e621/e926 have one requriement: use a custom user-agent that includes 
      #   your project name and username
      # There is a rate limit of two requests per second
      choosenAPI=$(curl -s --user-agent "domeScripts/1.0 (by Chad42Lion)" -H "Accept: application/json" "https://e621.net/posts.json?tags=rating%3A$choosenSafemode+$Tag&limit=$Limit" | jq -r --unbuffered '.posts[].file.url')
      Website="e621.net";;
    danbooru)
      # Danbooru API documentation: https://danbooru.donmai.us/wiki_pages/help:api
      # Note: "rating:safe" still show minor explicit images
      danbooruKeys
      choosenAPI=$(curl -s -A --user "$danbooruUser:$danbooruPass" -H "Content-Type application/json" "https://danbooru.donmai.us/posts.json?tags=rating%3A$choosenSafemode+$Tag&limit=$Limit" | jq -r --unbuffered '.[].file_url')
      Website="danbooru.donmai.us";;
  esac
  #echo $choosenAPI
}

showInputArgumentResults() {
  echo "Parsed arguments:"
  echo "  Tag: $Tag"
  echo "  Limit: $Limit"
  echo "  Safemode: $choosenSafemode"
  echo "  Website: $Website"
  echo "  Mode: $Mode"
  echo "  Slideshow-delay:  $SlideshowDelay"
  echo
}

# Call feh with the choosen website
# --reload=0 option disables reloading of images located on disk, and is included
# since the warning "feh WARNING: inotify_add_watch failed: No such file or directory"
# occurs
displayImage(){ 
  #echo "Mode: $Mode"
  #chooseURL ${Mode};
  #echo $choosenAPI
  feh --auto-zoom --fullscreen --hide-pointer --reload=0 --slideshow-delay $SlideshowDelay $choosenAPI
}

chooseURL ${Mode};
showInputArgumentResults
displayImage
exit 1;