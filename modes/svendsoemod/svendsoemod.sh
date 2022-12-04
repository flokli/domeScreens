#!/bin/bash
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Fetch the pages (comment this out after first run)
if ! [ -d $script_dir/svendsoemod.dk/ ]; do
  wget --recursive https://svendsoemod.dk
fi

# List of all html files
html_files=$(find . -type f | grep "\.html$")
# Count them
count_files=$(echo $html_files | wc -w)

while true; do
  # Random number in the range
  random_num=$(echo $(( $RANDOM % "$count_files" + 1 )) )
  # Get filename for the random number
  random_file=$(echo $html_files | cut -d " " -f $random_num)
  #killall firefox-esr
  # Open filename in firefox
  echo Opening "file://$script_dir/$random_file"
  firefox --kiosk --private-window "file://$script_dir/$random_file"
  sleep 30
done
