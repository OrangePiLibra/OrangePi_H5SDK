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
make -j4
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
BINARY_PATH=$ROOT/external
MERGE_TOOLS=$ROOT/toolchain/pack-tools
BUILD=$ROOT/output

echo "BINARY_PATH $BINARY_PATH"
echo "MERGE_TOOLS $MERGE_TOOLS"
echo "BUILD $BUILD"

# Check direct
if [ -d $BUILD ]; then
	echo "output has exist, you can start merge"
else
	mkdir -p $BUILD
	echo "output direct build finish."
fi

echo "Perpare binary to merge."
cp -avf $BINARY_PATH/bl31.bin $BUILD
cp -avf $BINARY_PATH/scp.bin $BUILD/scp.fex
cp -avf $BINARY_PATH/sys_config.fex $BUILD
cp -avf $UBOOT/u-boot-sun50iw2p1.bin $BUILD/u-boot.fex
cp -avf $UBOOT/sunxi_spl/boot0/boot0_sdcard.bin $BUILD/boot0_sdcard.fex

# Build binary device tree
dtc -Odtb -o $BUILD/orangepi.dtb $ROOT/kernel/arch/arm64/boot/dts/${PLATFORM}.dts 
cp $BUILD/orangepi.dtb $BUILD/sunxi.fex

cd $ROOT/output
# Build sys_config.bin
busybox unix2dos $BUILD/sys_config.fex
$MERGE_TOOLS/script $BUILD/sys_config.fex >/dev/null
cp $BUILD/sys_config.bin $BUILD/config.fex

# Merge DTS
$MERGE_TOOLS/update_uboot_fdt u-boot.fex sunxi.fex u-boot.fex >/dev/null

# Merge u-boot.bin infile outfile mode [secmonitor | secos | scp]
$MERGE_TOOLS/update_scp    scp.fex sunxi.fex >/dev/null
$MERGE_TOOLS/update_boot0  boot0_sdcard.fex sys_config.bin SDMMC_CARD > /dev/null
$MERGE_TOOLS/update_uboot  u-boot.fex sys_config.bin > /dev/null


#$MERGE_TOOLS/merge_uboot  u-boot.bin  bl31.bin  u-boot-merged.bin secmonitor
#$MERGE_TOOLS/merge_uboot  u-boot-merged.bin  scp.bin  u-boot-merged2.bin scp

# Merge uboot and dtb
#$MERGE_TOOLS/update_uboot_fdt u-boot-merged2.bin orangepi.dtb u-boot-with-dtb.bin

# Merge uboot and sys_config.fex
#$MERGE_TOOLS/update_uboot u-boot-with-dtb.bin sys_config.bin


# Clear build space
rm -rf u-boot-merg*
rm -rf sys_config.*
rm -rf bl31.bin
rm -rf orangepi.dtb
rm -rf sunxi.fex
rm -rf scp.fex

# Change to scripts direct.
cd -
whiptail --title "OrangePi Build System" \
	--msgbox "Build uboot finish. The output path: $BUILD/u-boot-with-dtb.bin" 10 60 0
