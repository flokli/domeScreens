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
What is shown on the screens will be controlable form MQTT, somehting like so

> topic /screens/"computer1"/"screen1"/mode <-- set mode
 
> topic /screens/"computer1"/"screen1"/tag  <-- set any tags or comands for the chosen mode.

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
Syntax: ./handlemessage.sh [gan|uni|sexgan|iv|aa|kill]
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