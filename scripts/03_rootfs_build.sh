#!/bin/bash
set -e
########################################################################
##
##
## Build rootfs
########################################################################
if [ -z $ROOT ]; then
	ROOT=`cd .. && pwd`
fi

if [ -z $1 ]; then
	DISTRO="jessie"
else
	DISTRO=$1
fi

BUILD="$ROOT/external"
OUTPUT="$ROOT/output"
DEST="$OUTPUT/rootfs"
LINUX="$ROOT/kernel"
SCRIPTS="$ROOT/scripts"
TOOLCHAIN="$ROOT/toolchain/gcc-linaro-aarch/bin/aarch64-linux-gnu-"

DEST=$(readlink -f "$DEST")
LINUX=$(readlink -f "$LINUX")

# Backup
cp -rfa $DEST $OUTPUT/${DISTRO}_rootfs

clear
whiptail --title "OrangePi Build System" \
	--msgbox "Build Rootfs Ok. The path of output: $DEST" 10 50 0
