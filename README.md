# Dome Scripts

This project have been developed to send messages over MQTT in order to run scripts on subscribers machines and show media content on their screens.

## Modes
The different modes can be found in the [modes directory](./modes/)

-	 gandalf
-	 gandalf-e621 (NSFW: sexy gandalf and furry)
-	 e621	(NSFW: Furry)
-	 e926	(SFW: Furry)
-  anime/danbooru (NSFW and SFW)
-	 Pink Fluffy Unicorns Dancing On Rainbows
-	 Ascii art

## MQTT 
Messages will be published to a topic through a MQTT broker and send to subscribers of that topic that will parse the arguments in [MQTT/handlemessage.sh](./MQTT/handleMessage.sh).
 The subscribers will run the corresponding modes script and be shown on the subscribers screen.

A topic can look like this
> /dome/screen

## MQTT broker and api login details
The file `secretFile.txt.example` must be renamed to `secretFile.txt` and be filled out with a MQTT brokerfor the publisher and subscriber to work correctly. Optinally  you can fill in the API login details for danbooru to make the anime mode work.

The `secretFile.txt` can look like this:
```
mqttbroker:example.com
danbooruUser:user
danooruPass:password
giphyAPIKey:
```

## Requirments

The following programs are required for the scripts to work

```
curl 
wget
feh (an image viewer)
mplayer (a video player)
termsaver (print text slowly in terminal)
fq  - Command-line JSON processor (json parser for e621 API) 
pv (for asciiArt)
lolcat (for asciiArt)
mosquitto ? 
mosquitto-clients ( to recive and hanndle the MQTT messages )
mpv
```

## Send a message
```bash
cd MQTT
./mqtt-publish.sh /some/topic -m "message"
```

### Help message
```bash
Syntax: ./mqtt-publish.sh /some/topic -m "mode and optinal message"
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

### e621

Help message from the [e621API.sh](./modes/e621/e621API.sh) script

```bash
Syntax: ./e621API.sh [-t|l|u|m|s|h]
Options:
  -t, --tag             Requested tag.
  -l, --limit           Limit of posts to fetch. Default is 50
  -s, --safemode        Select Safemode, default is SFW. Options are
                          NSFW, SFW, unsafe, safe, false or true.
  -m, --mode            Select e621 or anime mode. Default e621
  --slideshow-delay     Time between each image. Default is 1
  -h, --help            Print this help message
```

To send multiple tags add a plus (+) between the tags; example `--tag comfy+coffee`. If a tag needs to be filtered out, add a plus and a minus and then the tag; example `--tag witch+-broom`.

### Kill

* Kill an image viewer mode, send the message `"kill feh"`. 
* Kill a mode that show a video, send the message `"kill mplayer"`.
* Kill AsciiArt, send message `"kill asciiArt"`.

## Video stops on your potato computer
Add a fake pulseaudio sink with
```bash
pactl load-module module-null-sink
```

## CRT 
The [CRT directory](./crt/) contains files that are needed to run on the small CRT screen, with exepction of the ganfalf video that is located in the [videos direstory](./videos/)
