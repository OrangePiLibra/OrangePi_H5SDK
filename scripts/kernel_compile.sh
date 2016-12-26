#!/bin/bash
set -e
##############################################
##
## Compile kernel
##
##############################################
if [ -z $ROOT ]; then
	ROOT=`cd .. && pwd`
fi
# Platform
if [ -z $PLATFORM ]; then
	PLATFORM="OrangePiH5_PC2"
fi
# Cleanup
if [ -z $CLEANUP ]; then
	CLEANUP="0"
fi
# kernel option
if [ -z $BUILD_KERNEL ]; then
	BUILD_KERNEL="0"
fi
# module option
if [ -z $BUILD_MODULE ]; then
	BUILD_MODULE="0"
fi
# Knernel Direct
LINUX=$ROOT/kernel
# Compile Toolchain
TOOLS=$ROOT/toolchain/gcc-linaro-aarch/bin/aarch64-linux-gnu-
# OUTPUT DIRECT
BUILD=$ROOT/output
CORES=$((`cat /proc/cpuinfo | grep processor | wc -l` - 1))

if [ ! -d $BUILD ]; then
	mkdir -p $BUILD
fi 

# Perpare souce code
if [ ! -d $LINUX ]; then
	whiptail --title "OrangePi Build System" --msgbox \
		"Kernel doesn't exist, pls perpare linux source code." 10 40 0 --cancel-button Exit
	exit 0
fi

clear
echo -e "\e[1;31m Start Compile.....\e[0m"

if [ $CLEANUP = "1" ]; then
	make -C $LINUX ARCH=arm64 CROSS_COMPILE=$TOOLS clean
	echo -e "\e[1;31m Clean up kernel \e[0m"
fi

if [ ! -f $LINUX/.config ]; then
	make -C $LINUX ARCH=arm64 CROSS_COMPILE=$TOOLS ${PLATFORM}_linux_defconfig
	echo -e "\e[1;31m Using ${PLATFROM}_linux_defconfig \e[0m"
fi

if [ $BUILD_KERNEL = "1" ]; then
	# make kernel
	make -C $LINUX ARCH=arm64 CROSS_COMPILE=$TOOLS -j${CORES} Image
fi

if [ $BUILD_MODULE = "1" ]; then
	# make module
	echo -e "\e[1;31m Start Compile Module \e[0m"
	make -C $LINUX ARCH=arm64 CROSS_COMPILE=$TOOLS -j${CORES} modules

	# Compile Mali450 driver
	echo -e "\e[1;31m Compile Mali450 Module \e[0m"
	if [ ! -d $BUILD/lib ]; then
		mkdir -p $BUILD/lib
	fi 
	make -C ${LINUX}/modules/gpu ARCH=arm64 CROSS_COMPILE=$TOOLS LICHEE_KDIR=${LINUX} LICHEE_MOD_DIR=$BUILD/lib LICHEE_PLATFORM=linux
	echo -e "\e[1;31m Build Mali450 succeed \e[0m"

	# install module
	echo -e "\e[1;31m Start Install Module \e[0m"
	make -C $LINUX ARCH=arm64 CROSS_COMPILE=$TOOLS -j${CORES} modules_install INSTALL_MOD_PATH=$BUILD
	# Install mali driver
	MALI_MOD_DIR=$BUILD/lib/modules/`cat $LINUX/include/config/kernel.release 2> /dev/null`/kernel/drivers/gpu
	install -d $MALI_MOD_DIR
	mv ${BUILD}/lib/mali.ko $MALI_MOD_DIR
fi

if [ $BUILD_KERNEL = "1" ]; then
	# compile dts
	echo -e "\e[1;31m Start Compile DTS \e[0m"
	make -C $LINUX ARCH=arm64 CROSS_COMPILE=$TOOLS -j${CORES} dtbs
	#$ROOT/kernel/scripts/dtc/dtc -Odtb -o "$BUILD/OrangePiH5.dtb" "$LINUX/arch/arm64/boot/dts/${PLATFORM}.dts"
	## DTB conver to DTS
	# Command:
	# dtc -I dtb -O dts -o target_file.dts source_file.dtb
	########
	# Update DTB with uboot
	echo -e "\e[1;31m Cover sys_config.fex to DTS \e[0m"
	cd $ROOT/scripts/pack/
	./pack
	cd -

	# Perpare uImage
	mkimage -A arm -n "OrangePiH5" -O linux -T kernel -C none -a 0x40080000 -e 0x40080000 \
		-d $LINUX/arch/arm64/boot/Image $BUILD/uImage

	## Create uEnv.txt
	echo -e "\e[1;31m Create uEnv.txt \e[0m"
cat <<EOF > "$BUILD/uEnv.txt"
console=tty0 console=ttyS0,115200n8 no_console_suspend
kernel_filename=orangepi/uImage
initrd_filename=initrd.img
EOF

	## Build initrd.img
	echo -e "\e[1;31m Build initrd.img \e[0m"
	cp -rfa $ROOT/external/initrd.img $BUILD
fi 

clear
whiptail --title "OrangePi Build System" --msgbox \
	"Build Kernel OK. The path of output file: ${BUILD}" 10 80 0







