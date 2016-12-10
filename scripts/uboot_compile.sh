#!/bin/bash
set -e
#################################
##
## Compile U-boot
## This script will compile u-boot and merger with scripts.bin, bl31.bin and dtb.
#################################
# ROOT must be top direct.
if [ -z $ROOT ]; then
	ROOT=`cd .. && pwd`
fi
# PLATFORM.
if [ -z $PLATFORM ]; then
	PLATFORM="OrangePiH5_PC2"
fi
# Uboot direct
UBOOT=$ROOT/u-boot
# Compile Toolchain
TOOLS=$ROOT/toolchain/gcc-linaro-aarch/gcc-linaro/bin/arm-linux-gnueabihf-

BUILD=$ROOT/output
CORES=$((`cat /proc/cpuinfo | grep processor | wc -l` - 1))

# Perpar souce code
if [ ! -d $UBOOT ]; then
	whiptail --title "OrangePi Build System" \
		--msgbox "u-boot doesn't exist, pls perpare u-boot source code." \
		10 50 0
	exit 0
fi

cd $UBOOT
clear
echo "Compile U-boot......"
if [ ! -f $UBOOT/u-boot-sun50iw2p1.bin ]; then
	make  sun50iw2p1_config
fi
make -j${CORES}
echo "Complete compile...."

echo "Compile boot0......"
if [ ! -f $UBOOT/sunxi_spl/boot0/boot0_sdcard.bin ]; then
	make  sun50iw2p1_config
fi
make spl 
cd -
echo "Complete compile...."
#####################################################################
###
### Merge uboot with different binary
#####################################################################

cd $ROOT/scripts/pack/
./pack

###
# Cpoy output file
cp $ROOT/output/pack/out/boot0_sdcard.fex $ROOT/output/boot0.bin
cp $ROOT/output/pack/out/boot_package.fex $ROOT/output/uboot.bin

rm -rf $ROOT/output/pack/out

# Change to scripts direct.
cd -
whiptail --title "OrangePi Build System" \
	--msgbox "Build uboot finish. The output path: $BUILD" 10 60 0
