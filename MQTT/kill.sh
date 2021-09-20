pgrep -laP > ' ps -ef | grep handleMessage.sh | grep -v grep | awk '{print $2}''

#ps -ef | grep kill.sh | grep -v grep | awk '{print $2}' | xargs kill
#ps -ef | grep mplayer | grep -v grep | awk '{print $2}' | xargs kill
#./Test.sh

#echo $2

