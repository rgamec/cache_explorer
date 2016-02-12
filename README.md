## Introduction
Small script for generating an interactive display of all the images in your web browser's cache. Displayed as an animated HTML page. Inspired by Evan Roth's [Cache to Screensaver](http://www.evan-roth.com/work/cache-to-screensaver/) project.

## Caveats
Currently only supports Google Chrome running on Mac OS X.

## Usage 
1. Run "perl cache_explorer.pl" in a terminal, the script will process the cache and extract them to a folder called "cache_images" in the user's current directory.
2. Open cache_explorer.html in your browser to view the cache exploration tool.

## Todo
* Standardise script for use across Mac OS X, Linux, and Windows.
* Add support for additional web browsers if possible (Firefox, Internet Explorer, Opera, etc.)
* Convert existing JS-based "animation" to an HTML5 Canvas animation with more advanced display tools
* Add a screensaver mode

