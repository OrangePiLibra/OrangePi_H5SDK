#!/bin/bash
################################################
##
## Update Modules
################################################
set -e
if [ -z $ROOT ]; then
	ROOT=`cd .. && pwd`
fi
OUTPUT="$1"
BUILD=$ROOT/output

if [ -z "$OUTPUT" ]; then
	echo "Usage: $0 /medio/XXX/ROOTFS"
	exit 1
fi

if [ "$(id -u)" -ne "0" ]; then
	echo "This option requires root."
	echo "Pls use command: sudo ./scritps.sh"
	exit 0
fi

#####
# Remove old modules
echo -e "\e[1;31m Copying modules. \e[0m"
rm -rf $OUTPUT/lib/modules/*
cp -rfva $BUILD/lib/modules/* $OUTPUT/lib/modules/

echo -e "\e[1;31m Sync modules. \e[0m"
sync
clear
echo -e "\e[1;31m =================================== \e[0m"
echo -e "\e[1;31m Succeed to update Module \e[0m"
echo -e "\e[1;31m =================================== \e[0m"
