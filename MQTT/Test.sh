mosquitto_sub -h <host> -t <topic> | xargs -I %output% ./handleMessage.sh %output%
