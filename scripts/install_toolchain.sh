#!/bin/bash
set -e
#####################################
##
## Install cross toolchain
#####################################

if [ -z $TOOT ]; then
	ROOT=`cd .. && pwd`
fi

TOOLS="$ROOT/toolchain"
TOOLTARXZ="$ROOT/external/toolchain_tar/toolchain"
TOOLTAR="$ROOT/external/toolchain.tar.gz"
UBOOTTAR="$ROOT/external/uboot-tools.tar.gz"
UBOOTTARXZ="$ROOT/external/toolchain_tar/u-boot-compile-tools"
UBOOTS="$TOOLS/gcc-linaro-aarch"

whiptail --title "OrangePi Build System" --msgbox "Installing Cross-Tools. Pls wait a mount." --ok-button Continue 10 40 0

clear
if [ ! -d $TOOLS/gcc-linaro-aarch ]; then
	echo -e "\e[1;31m Uncompress toolchain.. \e[0m"
	cat ${TOOLTARXZ}* > ${TOOLTAR}

	tar xzvf $TOOLTAR -C $ROOT 
	rm -rf $TOOLTAR 
	rm -rf $TOOLS/gcc-linaro-aarch/gcc-linaro
fi

if [ -d $ROOT/toolchain/gcc-linaro-aarch/gcc-linaro/arm-linux-gnueabihf ]; then
	rm -rf $ROOT/toolchain/gcc-linaro-aarch/gcc-linaro
fi

if [ ! -d $TOOLS/gcc-linaro-aarch/gcc-linaro/arm-linux-gnueabi ]; then
	cat ${UBOOTTARXZ}* > ${UBOOTTAR}

	tar xzvf $UBOOTTAR -C $UBOOTS
	rm -rf $UBOOTTAR 
fi

whiptail --title "OrangePi Build System" --msgbox "Cross-Tools has installed." 10 40 0


