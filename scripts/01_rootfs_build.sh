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

if [ -z $DISTRO ]; then
	DISTRO="jessie"
fi

BUILD="$ROOT/external"
OUTPUT="$ROOT/output"
DEST="$OUTPUT/rootfs"
LINUX="$ROOT/kernel"
SCRIPTS="$ROOT/scripts"
TOOLCHAIN="$ROOT/toolchain/gcc-linaro-aarch/bin/aarch64-linux-gnu-"

DEST=$(readlink -f "$DEST")
LINUX=$(readlink -f "$LINUX")

mkdir "$DEST/lib/modules"
# Install Kernel modules
make -C $LINUX ARCH=arm64 CROSS_COMPILE=$TOOLCHAIN modules_install INSTALL_MOD_PATH="$DEST"
# Install Kernel firmware
make -C $LINUX ARCH=arm64 CROSS_COMPILE=$TOOLCHAIN firmware_install INSTALL_MOD_PATH="$DEST"
# Install Kernel headers
make -C $LINUX ARCH=arm64 CROSS_COMPILE=$TOOLCHAIN headers_install INSTALL_HDR_PATH="$DEST/usr"

# Backup
cp -rf $DEST $OUTPUT/${DISTRO}_rootfs

clear
echo -e "\e[1;31m ================================== \e[0m"
echo -e "\e[1;31m Done - Install Rootfs: $DEST \e[0m"
echo -e "\e[1;31m ================================== \e[0m"


