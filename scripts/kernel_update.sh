#!/bin/bash
set -e
##################################################
##
## Update kernel and DTS
##################################################
if [ -z $ROOT ]; then
	ROOT=`cd .. && pwd`
fi
KERNEL=$ROOT/output/uImage
KERNEL_PATH="$1"

if [ -z "$KERNEL_PATH" ]; then
	echo "Usage: $0 /media/XXX/BOOT"
	exit 1
fi

############################
## Backup
if [ ! -d $KERNEL_PATH/backup ]; then
	mkdir -p $KERNEL_PATH/backup
fi

echo "Backup...."
cp -rfa $KERNEL_PATH/orangepi $KERNEL_PATH/backup/
cp -rfa $KERNEL_PATH/uEnv.txt $KERNEL_PATH/backup/
cp -rfa $KERNEL_PATH/initrd.img $KERNEL_PATH/backup/
echo "Finish backup..."
echo "Start udpate kernel and dtb"
if [ ! -d $KERNEL_PATH/orangepi ]; then
	mkdir -p $KERNEL_PATH/orangepi
fi

# Update kernel and DTB
cp -rfa $ROOT/output/uImage			$KERNEL_PATH/orangepi/
#cp -rfa $ROOT/output/Image.version  $KERNEL_PATH/
cp -rfa $ROOT/output/initrd.img		$KERNEL_PATH/
cp -rfa $ROOT/output/uEnv.txt		$KERNEL_PATH/
cp -rfa $ROOT/output/OrangePiH5.dtb $KERNEL_PATH/orangepi/OrangePiH5orangepi.dtb

sync

echo -e "\e[1;31m ================================== \e[0m"
echo -e "\e[1;31m Succeed to update kernel \e[0m"
echo -e "\e[1;31m ================================== \e[0m"
