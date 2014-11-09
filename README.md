watchmeip-hack
==============

Nice hacks and tricks for WatchMeIP webcams.

## Misc links

### My webcam

* Brand/model: [WatchMeIP](http://watchmeip.com/) Indoor
* [WatchMeIP - Tutorial and Setup](http://www.youtube.com/watch?v=Bq4x52Z6nDs)

### Hacking webcams

* http://wiki.openipcam.com/index.php/Main_Page

### Videosorveglianza con Raspberry Pi
* [Videosorveglianza con Raspberry Pi](http://linuxdaytorino.org/2014/assets/slides/videosorveglianza.pdf) - [Francesco Tucci](http://www.francescotucci.com) @Linux Day Torino 2014
  * [Raspberry Pi](http://www.raspberrypi.org/)
  * [Tweepy](http://www.tweepy.org/) - An easy-to-use Python library for accessing the Twitter API
  * [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome) - a software motion detector
  * [Twitter](http://twitter.com)
  * [Pulseway](http://www.pulseway.com) - Remotely Monitor and Control IT Systems from any Smartphone or Tablet
    * Personal plan is free!
      * 5 monitored systems
      * 1 user accounts
      * 20 daily notifications
      * 2 mobile devices
  * Author's home pages:
    * http://www.iltucci.com
    * http://www.francescotucci.com

## Testing WatchMeIP control API

In the following section the Base URL of my WatchMeIP is http://cam01-internal.solarma.it (192.168.12.30).

Please replace Base URL according to your configuration.

### Login page

* http://cam01-internal.solarma.it/login.htm

### Main page

Must be previously authenticated with user,pwd

* http://cam01-internal.solarma.it/index1.htm

### Get status
* http://cam01-internal.solarma.it/get_status.cgi

```
var id='006E060704DA';
var sys_ver='0.41.2.47';
var app_ver='6.2.10.1';
var alias='';
var now=1415453750;
var tz=0;
var alarm_status=0;
var ddns_status=200;
var ddns_host='ihome365.org';
var oray_type=0;
var upnp_status=4;
var p2p_status=0;
var p2p_local_port=20436;
var msn_status=0;
var wifi_status=0;
var temperature=0.0;
var humidity=0;
```

### Returning "404 Not Found"

* http://cam01-internal.solarma.it/help

<!-- EOF -->
