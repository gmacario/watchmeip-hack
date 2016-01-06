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

## Unpacking `Pro_0_41_2_47.bin`

Download file `Pro_0_41_2_47.bin`

```
$ curl -o Pro_0_41_2_47.bin \
"http://watchmeip.com/support-download/all-downloads/firmware.html?task=download&tmpl=component&id=9"
```

Interpret header according to http://wiki.openipcam.com/index.php/Firmware_Structure

```
$ hexdump -Cv Pro_0_41_2_47.bin |head
00000000  42 4e 45 47 01 00 00 00  01 00 00 00 d5 df 0a 00  |BNEG............|
00000010  00 c8 0f 00 50 4b 03 04  14 00 02 00 08 00 59 3f  |....PK........Y?|
00000020  68 40 60 cd 38 e3 61 df  0a 00 48 d7 15 00 09 00  |h@`.8.a...H.....|
00000030  00 00 6c 69 6e 75 78 2e  62 69 6e ec fd 7d 7c 54  |..linux.bin..}|T|
00000040  47 bd 07 8e cf d9 dd 24  4b d8 c2 c9 13 a4 90 96  |G......$K.......|
00000050  03 a4 35 a5 69 7b 80 b4  a6 35 6d 97 42 2b 57 d0  |..5.i{...5m.B+W.|
00000060  2e 0f 6d d1 a2 a6 2d ad  a8 d4 a6 15 2b 5e b1 dd  |..m...-.....+^..|
00000070  24 9b 90 62 a0 01 c2 43  69 6c d6 16 bd d4 8b 57  |$..b...Cil.....W|
00000080  b4 d4 cb ad e8 dd 02 55  ac 54 a9 a5 5a 2b ea d9  |.......U.T..Z+..|
00000090  b3 1c 13 b2 68 a3 a2 62  c5 ee f7 fd 9e 99 cd 6e  |....h..b.......n|
```

**TIP**: to convert from hex to decimal and back you may use the following commands:

```
$ printf "%d\n" 0x000adfd5
$ printf "%x\n" 712661
```

Result:
* linux.bin: size=712661 (0x000adfd5); offset=20
* rootfs: size=1034240 (0x000fc800); offset=712681 (20+0x000adfd5)

Extract linux.bin, rootfs.bin from `Pro_0_41_2_47.bin`

```
$ dd if=Pro_0_41_2_47.bin of=linux.bin bs=1 count=$(printf "%d\n" 0x000adfd5) skip=20
$ dd if=Pro_0_41_2_47.bin of=rootfs.bin bs=1 count=$(printf "%d\n" 0x000fc800) skip=712681
```

Alternatively, you may use the script `unpack_firmware.sh` which does all the magic:

```
$ ./unpack_firmware.sh Pro_0_41_2_47.bin
```

You can then mount the rootfs with the following command

```
$ mkdir -p /tmp/rootfs
$ sudo mount -o ro rootfs.bin /tmp/rootfs
```


<!-- EOF -->
