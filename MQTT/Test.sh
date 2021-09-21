mosquitto_sub -h jwolf.net -t /bornhack/dome | xargs -I %output% ./handleMessage.sh %output%
