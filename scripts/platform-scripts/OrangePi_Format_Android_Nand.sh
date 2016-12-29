#!/bin/bash
#################################
#  Create Partion for Nand/EMMC

if [ ! -b /dev/mmcblk0p12 -o ! -b /dev/mmcblk0p8 ]; then
	exit 0
fi

if [ "$(id -u)" != "0" ]; then
   echo "Script must be run as root !"
   exit 0
fi


echo "==============================="
echo "Installing Linux system to emmc"
echo "==============================="

sdcard="/dev/mmcblk0"

echo "Erasing EMMC ..."
dd if=/dev/zero of=${sdcard} bs=1M count=32 > /dev/null 2>&1
sync
sleep 1

echo "Creating new filesystem on EMMC ..."
echo -e "o\nw" | fdisk ${sdcard} > /dev/null 2>&1
sync
echo "  New filesystem created on $sdcard."
sleep 1
partprobe -s ${sdcard} > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "ERROR."
    exit 1
fi
sleep 1

echo "Partitioning EMMC ..."
sfat=""
efat="4096"
echo "  Creating boot & linux partitions"
sext4=$(( $efat + 1))
eext4=""
echo -e "n\np\n1\n$sfat\n$efat\nn\np\n2\n$sext4\n$eext4\nt\n1\nb\nt\n2\n83\nw" | fdisk ${sdcard} > /dev/null 2>&1
echo "  OK."
sync
sleep 2
partprobe -s ${sdcard} > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "ERROR."
    exit 1
fi
sleep 1

echo "Formating fat partition ..."
dd if=/dev/zero of=${sdcard}p1 bs=1M count=1 oflag=direct > /dev/null 2>&1
sync
sleep 1
mkfs.vfat -n EMMCBOOT ${sdcard}p1 > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "  ERROR formating fat partition."
    exit 1
fi
echo "  fat partition formated."

dd if=/dev/zero of=${sdcard}p2 bs=1M count=1 oflag=direct > /dev/null 2>&1
sync
sleep 1
echo "Formating linux partition (ext4), please wait ..."
mkfs.ext4 -L emmclinux ${sdcard}p2 > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "ERROR formating ext4 partition."
    exit 1
fi
echo "  linux partition formated."

reboot
exit 0
