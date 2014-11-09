# Project: https://github.com/gmacario/watchmeip-hack
# File: configure-motion.awk
#
# Description: AWK file for editing motion.conf
# Please edit this file to match your configuration and requirements

BEGIN	{
	  print "# Created by Dockerfile"
	  print "# Please see https://github.com/gmacario/watchmeip-hack"
	  print "#"
	}
/^videodevice/ {
	  print "; " $0
	  next
	}
/^; netcam_url/ {
	  print "netcam_url http://cam01-internal.solarma.it/snapshot.cgi?user=admin&pwd=8iKu@kx!0&count=x"
	  next
	}
// 	{
	  print $0
	}

# EOF
