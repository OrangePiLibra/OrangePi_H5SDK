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

# Install Kernel modules
make -C $LINUX ARCH=arm64 CROSS_COMPILE=$TOOLCHAIN modules_install INSTALL_MOD_PATH="$DEST"
# Install Kernel firmware
make -C $LINUX ARCH=arm64 CROSS_COMPILE=$TOOLCHAIN firmware_install INSTALL_MOD_PATH="$DEST"
