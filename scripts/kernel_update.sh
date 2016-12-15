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

############################
## Backup
if [ ! -d $KERNEL_PATH/backup ]; then
	mkdir -p $KERNEL_PATH/backup
fi

cp -rfa $KERNEL_PATH/orangepi $KERNEL_PATH/backup/
cp -rfa $KERNEL_PATH/uEnv.txt $KERNEL_PATH/backup/
cp -rfa $KERNEL_PATH/initrd.img $KERNEL_PATH/backup/

whiptail --title "OrangePi Build System" \
	     --msgbox "Back and Update Kernel. Pls press Entry button" \
		 --ok-button Continue 10 60 

if [ ! -d $KERNEL_PATH/orangepi ]; then
	mkdir -p $KERNEL_PATH/orangepi
fi

# Update kernel and DTB
cp -rfa $ROOT/output/uImage			$KERNEL_PATH/orangepi/
cp -rfa $ROOT/output/initrd.img		$KERNEL_PATH/
cp -rfa $ROOT/output/uEnv.txt		$KERNEL_PATH/
cp -rfa $ROOT/output/OrangePiH5.dtb $KERNEL_PATH/orangepi/OrangePiH5.dtb

sync

whiptail --title "OrangePi Build System" \
		 --msgbox "Succeed to update kernel" \
		  10 60
