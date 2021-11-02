#!/bin/bash

echo "-----------------------------------------";
echo "Argument(s) given to handler: $@";
echo "Number of arguments: $#";
echo;

# Display help message
Help(){
  echo "MQTT handler to request different modes"
  echo
  echo "Syntax: ./handlemessage.sh [gan|uni|sexgan|iv|kill]"
  echo "Options:"
  echo "  gan, gandalf, --gandalf"
  echo "  uni, unicorn, --unicorn"
  echo "  sexgan, sexy-gandalf, --sexy-gandalf"
  echo "  iv, image-viewer, --image-viewer"
  echo "  kill, --kill"
  echo "  -h, --help            Print this help message"
  echo 
}

# Process arguments given to scirpt and call the corresponding script
processArguments() {
  while [[ "$@" != "" ]]; do
    case ${1} in
    gan | gandalf | --gandalf) cd ../modes/playVideo/; ./playGandalf.sh&;;
    uni | unicorn | --unicorn) cd ../modes/playVideo/; ./playPinkFluffyUnicorn.sh&;;
    sexgan | sexy-gandalf | --sexy-gandalf) cd ../modes/gandalf-e621/; ./gandalf-e621.sh&;;
    iv | image-viewer | --image-viewer) # ./handleMessage.sh iv "--tag bed --limit 10"
      shift 1; 
      ../modes//e621/e621API.sh ${@};;
    kill | --kill) # Kill processes
      shift 1;
      echo "Killing"; 
      echo "${@}"; 
      ./kill.sh ${@};;
    -h | --help) # Display help
      Help
      exit;;
    \?) echo "Error: Invalid option"; exit;;
    "") echo "Error: Empty argument in flag case"; exit;;
    *) # Default case, shift last argument(s)
      echo "Default case: "
      echo "  Argument before shift: ${1}"
      shift 1
      echo "  Argument after shift: ${1}"
      echo;;
    esac
    shift 1 # Shift arguments left 2 times, i.e. remove processed arguments
  done
}

processArguments $@
