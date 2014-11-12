Experimental Stuff
==================

TODO

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

### Inspecting rootfs.bin

#### Contents of `/bin`

```
gmacario@mv-linux-powerhorse:/tmp/rootfs$ ls -la bin/
total 0
drwxr-xr-x 1 root root     32 Jan  1  1970 .
drwxr-xr-x 1 root root     32 Jan  1  1970 ..
-rwxr-xr-x 1 root root 576741 Jan  1  1970 camera
-rwxr-xr-x 1 root root  44792 Jan  1  1970 dhcpcd
-rwxr-xr-x 1 root root    929 Jan  1  1970 fcc_ce.wlan
-rwxr-xr-x 1 root root  21610 Jan  1  1970 ifconfig
-rwxr-xr-x 1 root root    234 Jan  1  1970 init
-rwxr-xr-x 1 root root  12288 Jan  1  1970 .init.swo
-rwxr-xr-x 1 root root  38300 Jan  1  1970 iwconfig
-rwxr-xr-x 1 root root  33630 Jan  1  1970 iwpriv
drwxr-xr-x 1 root root     32 Jan  1  1970 mypppd
-rwxr-xr-x 1 root root  28824 Jan  1  1970 route
-rwxr-xr-x 1 root root  31043 Jan  1  1970 sh
-rwxr-xr-x 1 root root  48520 Jan  1  1970 wetctl
-rwxr-xr-x 1 root root  96327 Jan  1  1970 wpa_supplicant
gmacario@mv-linux-powerhorse:/tmp/rootfs$
```

#### Contents of `/bin/init`

```
mount -t proc none /proc
mount -t ramfs none /usr
mount -t ramfs none /swap
mount -t ramfs none /var/run
mount -t ramfs none /etc
mount -t ramfs none /flash
mount -t ramfs none /home
mount -t ramfs none /tmp
mkdir /tmp/run
camera&
sh
```

#### Inspecting `/bin/camera`

```
gmacario@mv-linux-powerhorse:/tmp/rootfs$ file bin/camera
bin/camera: BFLT executable - version 4 ram gzip
gmacario@mv-linux-powerhorse:/tmp/rootfs$
```

TODO

Add to README.md
================

## Misc Links

* [IP Camera WiFi (FOSCAM clone) model APEXIS APM-J1011 PCB Pan Tilt IR - How to disassemble](https://plus.google.com/photos/114674154535233763915/albums/5487561409982393617) - photos by Paillassou Paillasou, 2010-06-27
* [OpenIPCAM Wiki](http://wiki.openipcam.com/index.php/Main_Page) - ARM7 and ARM9 embedded ARM device IP Camera Wiki
  * [OpenIPCAM - Firmware Structure](http://wiki.openipcam.com/index.php/Firmware_Structure)
    * 20-byte header: 'BNEG' + 0x1L + 0x1L + size of linux.bin + size of rootfs
* [The structure of a PKZip file](https://users.cs.jmu.edu/buchhofp/forensics/formats/pkzip.html) - by Florian Buchholz
* [Linux Kernel doc/Documentation/filesystems/romfs.txt](https://www.kernel.org/doc/Documentation/filesystems/romfs.txt)

## Testing WatchMeIP control API

### Get a snapshot

Must be previously authenticated with user,pwd

http://cam01-internal.solarma.it/snapshot.cgi

## Reverse engineering cam01

Ethernet MAC address: 00:6E:06:07:04:DA
* Vendor: Unknown

Fingerprinting cam01 OS
```
gmacario@kruk:~$ sudo nmap -O cam01-internal.solarma.it

Starting Nmap 6.40 ( http://nmap.org ) at 2014-11-08 15:22 CET
Nmap scan report for cam01-internal.solarma.it (192.168.12.30)
Host is up (0.00075s latency).
rDNS record for 192.168.12.30: denergsrv4.polito.it
Not shown: 999 closed ports
PORT   STATE SERVICE
80/tcp open  http
MAC Address: 00:6E:06:07:04:DA (Unknown)
Device type: specialized|webcam
Running: AirMagnet Linux 2.4.X, Foscam Linux 2.4.X, Instar Linux 2.4.X
OS CPE: cpe:/h:airmagnet:smartedge cpe:/h:foscam:fi8904w cpe:/h:foscam:f18910w cpe:/h:foscam:f18918w cpe:/h:instar:in-3010
OS details: AirMagnet SmartEdge wireless sensor; or Foscam FI8904W, FI8910W, or FI8918W, or Instar IN-3010 surveillance camera (Linux 2.4)
Network Distance: 1 hop

OS detection performed. Please report any incorrect results at http://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 48.69 seconds
gmacario@kruk:~$
```

Downloading Firmware 0_41_2_47 from http://watchmeip.com/support-download/all-downloads/firmware/file/firmware-0-41-2-47.html?id=9

```
gmacario@ITM-GMACARIO-W7 ~/MYGIT/gm-personal/gmoffice/20141108-WatchMeIp_Firmware
$ ls -la
total 1728
drwxr-xr-x+ 1 gmacario       Domain Users       0 Nov  8 15:29 .
drwxr-xr-x+ 1 gmacario       Domain Users       0 Nov  8 15:29 ..
-rwx------+ 1 Administrators Domain Users 1746921 Nov  8 15:27 Pro_0_41_2_47.bin

gmacario@ITM-GMACARIO-W7 ~/MYGIT/gm-personal/gmoffice/20141108-WatchMeIp_Firmware
$
```

Trying Motion
=============

## Check-out gmacario/watchmeip-hack

```
git clone git@github.com:gmacario/watchmeip-hack.git
cd watchmeip-hack
```

Create a Docker container to play with

```
TODO: docker run -d -P gmacario/baseimage:0.9.15
docker run -t -i ubuntu:14.04
```

Inside the container

```
sudo apt-get update
sudo apt-get -y install motion
```

Notice that last command install system user "motion":

```
root@bee90949f3f4:~# grep motion /etc/passwd
motion:x:102:105::/home/motion:/bin/false
root@bee90949f3f4:~#
```

Edit `motion.conf`

```
mkdir -p $HOME/.motion
cp /etc/motion/motion.conf $HOME/.motion
vi $HOME/.motion/motion.conf
```

http://cam01-internal.solarma.it/snapshot.cgi?user=admin&pwd=8iKu@kx!0&count=309740

Apply the following changes:
```
root@bee90949f3f4:~/.motion# diff -uw /etc/motion/motion.conf motion.conf
--- /etc/motion/motion.conf     2014-03-10 16:33:19.000000000 +0000
+++ motion.conf 2014-11-09 07:33:03.354816657 +0000
@@ -26,7 +26,7 @@

 # Videodevice to be used for capturing  (default /dev/video0)
 # for FreeBSD default is /dev/bktr0
-videodevice /dev/video0
+; videodevice /dev/video0

 # v4l2_palette allows to choose preferable palette to be use by motion
 # to capture from those supported by your videodevice. (default: 8)
@@ -84,6 +84,7 @@
 # URL to use if you are using a network camera, size will be autodetected (incl http:// ftp:// or file:///)
 # Must be a URL that returns single jpeg pictures or a raw mjpeg stream. Default: Not defined
 ; netcam_url value
+netcam_url http://cam01-internal.solarma.it/snapshot.cgi?user=admin&pwd=8iKu@kx!0&count=x

 # Username and password for network camera (only if required). Default: not defined
 # Syntax is user:password
root@bee90949f3f4:~/.motion#
```

## Running motion inside a Docker container

```
$ docker build -t gmacario/motion .
$ docker run -d -P -v $PWD/snapshots:/tmp/motion gmacario/motion
```

<!-- EOF -->
