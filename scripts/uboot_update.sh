#!/bin/bash
set -e
#########################################################
##
##
## Update uboot and boot0
#########################################################
# ROOT must be top direct
if [ -z $ROOT ]; then
	ROOT=`cd .. && pwd`
fi
# Output path, must /dev/sdx
OUTPUT="$1"

if [ -z "$OUTPUT" ]; then
	echo "Usage: $0 /dev/sdx"
	exit 1
fi

if [ "$(id -u)" -ne "0" ]; then
	echo "This option requires root."
	echo "Pls use command: sudo ./scripts.sh"
	exit 0
fi
UBOOT=$ROOT/external/uboot.bin
BOOT0=$ROOT/external/boot0.bin

# Clean SD partition
dd bs=1K seek=8 count=1015 if=/dev/zero of="$OUTPUT"
# Update boot0
dd bs=1K seek=8 if="$BOOT0" of="$OUTPUT"
# Update uboot
dd bs=1K seek=16400 if="$UBOOT" of="$OUTPUT"

sync
echo -e "\e[1;31m ================================= \e[0m"
echo -e "\e[1;31m Succeed to Update Uboot and boot0 \e[0m"
echo -e "\e[1;31m ================================= \e[0m"
