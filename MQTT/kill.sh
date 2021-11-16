#!/bin/bash
echo "-----------------------------------------";
echo "Argument(s) given to kill script: $@";
echo "Number of arguments: $#";
echo;

# Display help message
Help(){
  echo "Kill modes"
  echo
  echo "Syntax: ./kill.sh [feh|mplayer|asciiArt]"
	echo ' Example message recieved from MQTT broker: "kill feh"'
  echo "Options:"
  echo "  feh"
  echo "  mplayer"
  echo "  asciiArt"
  echo "  -h, --help            Print this help message"
  echo 
}

#Finding the process
GettingProcess=$(pgrep -f "$1")

#setting into array, only needed id there are other things that is viewing or running
FilterIfMore=(${GettingProcess// /})
echo "Getting process $GettingProcess"

if [ "$(pgrep -a $1)" == "" ]; then
	echo "--------------------------------" 
	Help
	echo "--------------------------------"
	echo "ERROR: 404"
	exit 1;
elif  [  "$1" == "mplayer" ]; then
	echo "Kill mplayer"
	#getting the tree of processes tree this is including parrents
	GettingTreeProcess=$(pstree -s -p ${FilterIfMore[0]} | grep -o '([0-9]\+)' | grep -o '[0-9]\+')
	#adding all process ids to array
	TreeToArray=(${GettingTreeProcess// /})
	#kill -- ${TreeToArray[2]}
	#echo "First kill ${TreeToArray[4]}"
	#echo "Second kill${TreeToArray[5]}"
	#this will kill depending on what you want to kill, at the moment for me this will kill the konsol running the bashs$
	kill -- ${TreeToArray[4]}
	kill -- ${TreeToArray[5]}
elif  [  "$1" == "feh" ]; then
	echo "Kill feh"
	echo "Getting feh $GettingProcess"
	GettingTreeProcess=$(pstree -s -p ${FilterIfMore[0]} | grep -o '([0-9]\+)' | grep -o '[0-9]\+')
	TreeToArray=(${GettingTreeProcess// /})
	echo "0 ${TreeToArray[4]}"
	echo "0 ${TreeToArray[5]}"
	kill -- ${TreeToArray[4]}
	kill -- ${TreeToArray[5]}
	#kill -- $GettingProcess
elif  [  "$1" == "asciiArt" ]; then
	echo "Kill asciiart"
	GettingTreeProcess=$(pstree -s -p ${FilterIfMore[0]} | grep -o '([0-9]\+)' | grep -o '[0-9]\+')
	TreeToArray=(${GettingTreeProcess// /})
	#	echo $GettingTreeProcess
	echo ${TreeToArray[4]}
	kill -- ${TreeToArray[4]}
fi

#not tested on the other processes, but it should work

#Good for getting the tree
#pstree -p 17765

