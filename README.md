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

## CRT 
The [CRT directory](./crt/) contains files that are needed to run on the small CRT screen, with exepction of the ganfalf video that is located in the [videos direstory](./videos)

## Requirments

The following programs are required for the scripts to work

```
curl 
wget
feh (an image viewer)
mplayer (a video player)
termsaver (print text slowly in terminal)
```
