#!/bin/bash
set -e
########################################
##
## Change different platform
########################################
if [ -z $ROOT ]; then
	ROOT=`cd .. && pwd`
fi

if [ -z $1 ]; then
	PLATFORM="OrangePiH5_PC2"
else
	PLATFORM=$1
fi
#
VERSION=$ROOT/scripts/version
SYS_CONFIG=$ROOT/external/sys_config
BUILD=$ROOT/external
DTS=$ROOT/kernel/arch/arm64/boot
UBOOT=$ROOT/u-boot/include/configs

if [ ! -f $VERSION ]; then
	echo 0 > $VERSION
fi
# On .version: 0- OrangePi PC2. 1- is OrangePi3 2- OrangePi Zero+2 
VALUE=`cat $VERSION`
if [ $VALUE = "0" ]; then
	OLD_PLATFORM="OrangePiH5_PC2"
elif [ $VALUE = "1" ]; then
	OLD_PLATFORM="OrangePiH5_Prima"
elif [ $VALUE = "2" ]; then
	OLD_PLATFORM="OrangePiH5_Zero_Plus2"
fi

if [ $PLATFORM = $OLD_PLATFORM ]; then
	exit 0
fi 

# Change to OrangePi PC2
if [ $PLATFORM = "OrangePiH5_PC2" ]; then
	echo 0 > $VERSION
elif [ $PLATFORM = "OrangePiH5_Prima" ]; then
	echo "1" > $VERSION
elif [ $PLATFORM = "OrangePiH5_Zero_Plus2" ]; then
	echo 2 > $VERSION
fi

# backup other version
cp $BUILD/sys_config.fex $SYS_CONFIG/${OLD_PLATFORM}_sys_config.fex > /dev/null  2>&1
# Change current version sys_config.fex
cp $SYS_CONFIG/${PLATFORM}_sys_config.fex $BUILD/sys_config.fex > /dev/null  2>&1

# Backup DTS version
if [ -d $DTS/${OLD_PLATFORM}_dts ]; then
	rm -rfv $DTS/${OLD_PLATFORM}_dts 
fi
mv $DTS/dts $DTS/${OLD_PLATFORM}_dts 
# Change current DTS version 
mv $DTS/${PLATFORM}_dts $DTS/dts 

# Backup .config
if [ -f $ROOT/kernel/.config ]; then
	mv $ROOT/kernel/.config $ROOT/kernel/arch/arm64/configs/${OLD_PLATFORM}_linux_defconfig > /dev/null  2>&1
fi
cp $ROOT/kernel/arch/arm64/configs/${PLATFORM}_linux_defconfig $ROOT/kernel/.config > /dev/null  2>&1

# Backup uboot/include/configs/***.h
if [ -f $UBOOT/${OLD_PLATFORM}_sun50iw2p1.h ]; then
	rm -rfv $UBOOT/${OLD_PLATFORM}_sun50iw2p1.h 
fi
mv $UBOOT/sun50iw2p1.h $UBOOT/${OLD_PLATFORM}_sun50iw2p1.h
# Change current DTS version 
mv $UBOOT/${PLATFORM}_sun50iw2p1.h $UBOOT/sun50iw2p1.h
