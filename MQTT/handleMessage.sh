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

  *)
    echo "error from" 
    echo $1
    ;;
esac

