#!/bin/bash
#
# Project: 
# Purpose: Pack OpenIPCAM firmware image
# See http://wiki.openipcam.com/index.php/Firmware_Structure

set -e

LINUXBIN_FILE=linux.bin
ROOTFS_FILE=rootfs.bin
OUTFILE=output.bin

# Sanity checks
if [ ! -e ${LINUXBIN_FILE} ]; then
    echo ERROR: Cannot find ${LINUXBIN_FILE}
    exit 1
fi
if [ ! -e ${ROOTFS_FILE} ]; then
    echo ERROR: Cannot find ${ROOTFS_FILE}
    exit 1
fi

# Fixed header (12 bytes)
echo -n -e "\x42\x4E\x45\x47" >${OUTFILE}
echo -n -e "\x01\x00\x00\x00" >>${OUTFILE}
echo -n -e "\x01\x00\x00\x00" >>${OUTFILE}

# Size of LINUXBIN_FILE (4 bytes)
#echo -n -e "\x00\x00\x00\x00" >>${OUTFILE}
linuxbin_sz=$(stat -c %s ${LINUXBIN_FILE})
echo DEBUG: linuxbin_sz=${linuxbin_sz}
printf "000C: %.8x" ${linuxbin_sz}  | \
    sed -E 's/(..)(..)(..)(..)$/\4\3\2\1/' | \
    xxd -r - ${OUTFILE}

# Size of ROOTFS_FILE (4 bytes)
#echo -n -e "\x00\x00\x00\x00" >>${OUTFILE}
rootfs_sz=$(stat -c %s ${ROOTFS_FILE})
echo DEBUG: rootfs_sz=${rootfs_sz}
printf "0010: %.8x" ${rootfs_sz}  | \
    sed -E 's/(..)(..)(..)(..)$/\4\3\2\1/' | \
    xxd -r - ${OUTFILE}

# Contents of LINUXBIN_FILE (linuxbin_sz)
cat ${LINUXBIN_FILE} >>${OUTFILE}

# Contents of ROOTFS_FILE (rootfs_sz)
cat ${ROOTFS_FILE} >>${OUTFILE}

echo INFO: Output file created as ${OUTFILE}

# DEBUG
#hexdump -Cv ${OUTFILE} | head
#xxd -g1 ${OUTFILE} | head

# EOF
