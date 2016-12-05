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

FILE_NUM=$(ls $BUILD/lib/modules -lR | grep "^-" | wc -l)
#####
# Remove old modules
rm -rf $OUTPUT/lib/modules/*
cp -rfa $BUILD/lib/modules/* $OUTPUT/lib/modules/ &

{
	for ((i = 0; i < 100; )); do
		CUR_FILE=$(ls $OUTPUT/lib/modules -lR | grep "^-" | wc -l)
		i=$[ CUR_FILE * 100 / FILE_NUM ]
		echo i
	done
} | whiptail --gauge "Update modules into SDcard" 6 60 0

sync &
clear
whiptail --title "OrangePi Build System" \
	     --msgbox "Succeed to update Module" \
		 10 40 0 
