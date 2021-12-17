#!/bin/bash
#
# This program can take arguments and show images from e621, e926 and danbooru
#  related to a tag for the the images. Image viewing is using feh and
#  JSON given from the site are parsed by jq.
#
# The script have been developed with MQTT in mind and have an option
#  to split up a single argument into multiple arguments
#
# Dependencies: curl, feh, jq


# Print all arguments and amount of arguments
ArgumentsGiven() {
cat <<EOF
-----------------------------------------
Argument(s) given: $@"
Number of arguments: $#"

EOF
}

# Help message displayed i case of no arguments are given, invalid arguments or if '--help' is as argument.
# Using 'cat << EOF' to output multiline text and avoid using 'echo' for each line.
Help(){
cat <<EOF
This script requests posts from e621 or e926 related to a tag
Requirements to run script: curl, jq, feh

Syntax: ./e621API.sh [-t|l|u|m|s|h]
Options:
  -t, --tag             Requested tag.
  -l, --limit           Limit of posts to fetch. Default is 50
  -s, --safemode        Select Safemode, default is SFW. Options are
                          NSFW, SFW, unsafe, safe, false or true.
  -m, --mode            Select e621 or anime mode. Default e621
  --slideshow-delay     Time between each image. Default is 1
  -h, --help            Print this help message

EOF
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
CheckIfNullInput() {
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
}

# Translate safemode to website
SetSafeMode() {
  if [ $1 == false ]; then
    choosenSafemode=explicit #NSFW
  else
    choosenSafemode=safe #SFW
  fi
}

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
  feh --auto-zoom --fullscreen --hide-pointer --reload=0 --slideshow-delay $SlideshowDelay $choosenAPI
}

# Check if depency is present. 
# From: https://github.com/sdushantha/tmpmail/blob/8fa8e93aebb4521fa2715c1dc6b76c52ec754345/tmpmail
CheckDependency() {
  # Iterate of the array of dependencies and check if the user has them installed.
  #
  # dep_missing allows us to keep track of how many dependencies the user is missing
  # and then print out the missing dependencies once the checking is done.
  dep_missing=""
  for dependency in jq feh curl; do
      if ! command -v "$dependency" >/dev/null 2>&1; then
          # Append to our list of missing dependencies
          dep_missing="$dep_missing $dependency"
      fi
  done

  if [ "${#dep_missing}" -gt 0 ]; then
      echo "Could not find the following dependencies:$dep_missing"
      exit 1
  fi
}

Main() {
  CheckDependency
  ArgumentsGiven $@
  CheckIfNullInput $@
  SetSafeMode ${Safemode}
  chooseURL ${Mode}
  showInputArgumentResults
  displayImage
  exit 1;
}

Main "$@"