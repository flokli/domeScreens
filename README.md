# Dome Scripts
Cursed and blesses scripts for Habitorium screens


## Modes
The different modes can be found in the [modes directory](./modes/)

-	 gandalf
-	 gandalf-e621 (NSFW: sexy gandalf and furry)
-	 e621	(NSFW: Furry)
-	 e926	(SFW: Furry)
-	 Pink Fluffy Unicorns Dancing On Rainbows
-	 Ascii art

## MQTT 
Messages will be published to a topic through a MQTT broker and send to subscribers of that topic that will parse the arguments in [MQTT/handlemessage.sh](MQTT/handlemessage.sh). The subscribers will run the corresponding modes script and be shown on the subscribers screen.

A topic can look like this
> /dome/screen

## Requirments

The following programs are required for the scripts to work

```
curl 
wget
feh (an image viewer)
mplayer (a video player)
termsaver (print text slowly in terminal)
fq (json parser for e621 API)
pv (for asciiArt)
lolcat (for asciiArt)
```

## Send a message
```bash
cd MQTT
./mqtt-publish.sh /some/topic -m "message"
```

### Help message
```bash
Syntax: ./mqtt-publish.sh /some/topic -m "message"
  Example: ./mqtt-publish.sh /test/topic -m "iv --tag bed --limit 10 --safemode true"
Options:
  gan, gandalf, --gandalf
  uni, unicorn, --unicorn
  sexgan, sexy-gandalf, --sexy-gandalf
  iv, image-viewer, --image-viewer
  aa, asciiArt
  kill, --kill
  -h, --help            Print this help message
```

### Kill

To kill a script give one of the matching messages.
```
kill feh
kill mplayer
```

## CRT 
The [CRT directory](./crt/) contains files that are needed to run on the small CRT screen, with exepction of the ganfalf video that is located in the [videos direstory](./videos)