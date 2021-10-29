# E621 and E926 tag image viewer 

```bash
This script requests posts from e621 or e926 related to a tag
Requirements to run script: curl, jq, feh

Syntax: ./e621API.sh [-t|l|u|h]
Options:
  -t, --tag             Requested tag.
  -l, --limit           Limit of posts to fetch. Default is 50
  -s, --safemode        Select Safemode, default is SFW. Options are
                          NSFW, SFW, unsafe, safe, false or true.
  --slideshow-delay     Time between each image. Default is 1
  -h, --help            Print this help message
```

API documentation for e621 API: [https://e621.net/help/api](https://e621.net/help/api)
