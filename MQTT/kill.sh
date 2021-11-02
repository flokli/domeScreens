#!/bin/bash
echo "-----------------------------------------";
echo "Argument(s) given to kill script: $@";
echo "Number of arguments: $#";
echo;

#Finding the process
GettingProcessCount=$(pgrep -f -c "$1")
GettingProcess=$(pgrep -f "$1")

echo "Getting process $GettingProcessCount"
echo "Getting process $GettingProcess"

if [ $(pgrep -f -c "$1") == 2 ]; then
	echo "ERROR 404"
	exit 1;
fi
#setting into array, only needed id there are other things that is viewing or running
FilterIfMore=(${GettingProcess// /})
echo ${FilterIfMore[0]}

#getting the tree of processes tree this is including parrents
GettingTreeProcess=$(pstree -s -p ${FilterIfMore[0]} | grep -o '([0-9]\+)' | grep -o '[0-9]\+')
#adding all process ids to array
TreeToArray=(${GettingTreeProcess// /})
#kill -- ${TreeToArray[2]}
echo "First kill ${TreeToArray[3]}"
echo "Second kill${TreeToArray[4]}"
#this will kill depending on what you want to kill, at the moment for me this will kill the konsol running the bashscript on my computer. this may differ depending on system
#kill -- ${TreeToArray[4]}
#kill -- ${TreeToArray[5]}

#not tested on the other processes, but it should work

#Good for getting the tree
#pstree -p 17765
