cd /home/richard/domeScreens/modes/Vids
# $1

case $1 in

  gan)
    sh Play-gandalf.sh
    ;;

  uni)
    sh Play-PFUDOR.sh
    ;;

  porn)
    echo "e621 ?"
    ;;
  kill)
    echo "killing"
    sh ~/domeScreens/MQTT/kill.sh
    ;; 
  *)
    echo "error from" 
    echo $1
    ;;
esac

