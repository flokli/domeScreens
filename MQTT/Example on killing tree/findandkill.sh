#!/bin/bash
#Finding the process
GettingProcess=$(pgrep -f "LoopBash.sh")
echo $GettingProcess

#setting into array, only needed id there are other things that is viewing or running
FilterIfMore=(${GettingProcess// /})
echo ${FilterIfMore[1]}

#getting the tree of processes tree this is including parrents
GettingTreeProcess=$(pstree -s -p ${FilterIfMore[1]} | grep -o '([0-9]\+)' | grep -o '[0-9]\+')
#adding all process ids to array
TreeToArray=(${GettingTreeProcess// /})
echo ${TreeToArray[2]}
#this will kill depending on what you want to kill, at the moment for me this will kill the konsol running the bashscript on my computer. this may differ depending on system
kill -- ${TreeToArray[2]}

#not tested on the other processes, but it should work

#Good for getting the tree
#pstree -p 17765
