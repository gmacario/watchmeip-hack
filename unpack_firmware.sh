#!/bin/bash
#
# Project: 
# Purpose: Unpack OpenIPCAM firmware image
# See http://wiki.openipcam.com/index.php/Firmware_Structure

set -e

PACKED_FILE=Pro_0_41_2_47.bin
LINUXBIN_FILE=linux.bin
ROOTFS_FILE=rootfs.bin

# Sanity checks
if [ ! -e ${PACKED_FILE} ]; then
    echo ERROR: Cannot find ${PACKED_FILE}
    exit 1
fi

## Fixed header (12 bytes)
#echo -n -e "\x42\x4E\x45\x47" >${OUTFILE}
#echo -n -e "\x01\x00\x00\x00" >>${OUTFILE}
#echo -n -e "\x01\x00\x00\x00" >>${OUTFILE}

# Size of LINUXBIN_FILE (4 bytes)
linuxbin_offset=20
linuxbin_sz=$(printf "%d\n" $(xxd -g1 -s12 -l4 ${PACKED_FILE} | \
    sed -E 's/.*: (..) (..) (..) (..).*$/0x\4\3\2\1/'))
echo "DEBUG: linuxbin_offset=${linuxbin_offset}; linuxbin_sz=${linuxbin_sz}"

# Size of ROOTFS_FILE (4 bytes)
rootfs_offset=$(expr ${linuxbin_offset} + ${linuxbin_sz})
rootfs_sz=$(printf "%d\n" $(xxd -g1 -s16 -l4 ${PACKED_FILE} | \
    sed -E 's/.*: (..) (..) (..) (..).*$/0x\4\3\2\1/'))
echo "DEBUG: rootfs_offset=${rootfs_offset}; rootfs_sz=${rootfs_sz}"
#echo -n -e "\x00\x00\x00\x00" >>${OUTFILE}
#rootfs_sz=$(stat -c %s ${ROOTFS_FILE})
#echo DEBUG: rootfs_sz=${rootfs_sz}
#printf "0010: %.8x" ${rootfs_sz}  | \
#    sed -E 's/(..)(..)(..)(..)$/\4\3\2\1/' | \
#    xxd -r - ${OUTFILE}

# Create LINUXBIN_FILE
dd if=${PACKED_FILE} of=${LINUXBIN_FILE} bs=1 \
    skip=${linuxbin_offset} count=${linuxbin_sz}
echo "INFO: LINUXBIN_FILE created as ${LINUXBIN_FILE}"

# Create ROOTFS_FILE
dd if=${PACKED_FILE} of=${ROOTFS_FILE} bs=1 \
    skip=${rootfs_offset} count=${rootfs_sz}
echo "INFO: ROOTFS_FILE created as ${ROOTFS_FILE}"

# EOF
