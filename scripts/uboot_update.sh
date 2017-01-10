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

UBOOT=$ROOT/output/uboot.bin
BOOT0=$ROOT/output/boot0.bin

# Clean SD partition
sudo dd bs=1K seek=8 count=1015 if=/dev/zero of="$OUTPUT"
# Update boot0
sudo dd bs=1K seek=8 if="$BOOT0" of="$OUTPUT"
# Update uboot
sudo dd bs=1K seek=16400 if="$UBOOT" of="$OUTPUT"

sync
clear
whiptail --title "OrangePi Build System" --msgbox "Succeed to update Uboot and boot0" 10 40 0
