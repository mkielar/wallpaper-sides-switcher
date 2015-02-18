# wallpaper-sides-switcher
Switches wallpaper tiles for multimonitor Windows 7 setup

#### Requirements
This script has been tested on Windows 7 running Cygwin with ImageMagic installed.

Versions:
* Cygwin: `1.7.34(0.285/5/3) 2015-02-04 12:12 i686` 
* ImageMagic `6.9.0.0-3`.

#### Usage
```bash
./wss.sh -i "wallpaper.jpg" -w 1920 -h 1080 -o 2,1
```
where:
```
-i | --input  Input file
              Wildcards are accepted, just make sure you put everything in "double quotes".
              
-w | --width  Tile width
-h | --height Tile height
              Size of the tile. Tile is started at 0x0 (top-left corner),
              so if the original image is higher than "height" it will be cropped.

-o | --order  New order of tiles
              The top-left tile has index "1", next tile is cropped to the right of the first one, 
              and so on... Then they are appended one by one with specified order.
```  




