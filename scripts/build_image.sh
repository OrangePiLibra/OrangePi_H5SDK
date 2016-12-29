#!/bin/bash
################################################################
##
##
## Build Release Image
################################################################
set -e

if [ -z $ROOT ]; then
	ROOT=`cd .. && pwd`
fi

if [ -z $1 ]; then
	PLATFORM="OrangePiH5_PC2"
else
	PLATFORM=$1
fi

BUILD="$ROOT/external"
OUTPUT="$ROOT/output"
IMAGE="$OUTPUT/${PLATFORM}.img"
ROOTFS="$OUTPUT/rootfs"
disk_size="1200"

if [ -z "$disk_size" ]; then
	disk_size=100 #MiB
fi

if [ "$disk_size" -lt 60 ]; then
	echo "Disk size must be at least 60 MiB"
	exit 2
fi

echo "Creating image $IMAGE of size $disk_size MiB ..."

boot0="$ROOT/output/boot0.bin"
uboot="$ROOT/output/uboot.bin"

# Partition Setup
boot0_position=8      # KiB
uboot_position=16400  # KiB
part_position=20480   # KiB
boot_size=50          # MiB

set -x

# Create beginning of disk
dd if=/dev/zero bs=1M count=$((part_position/1024)) of="$IMAGE"
dd if="$boot0" conv=notrunc bs=1k seek=$boot0_position of="$IMAGE"
dd if="$uboot" conv=notrunc bs=1k seek=$uboot_position of="$IMAGE"

# Create boot file system (VFAT)
dd if=/dev/zero bs=1M count=${boot_size} of=${IMAGE}1
mkfs.vfat -n BOOT ${IMAGE}1

if [ -d $OUTPUT/orangepi ]; then
	rm -rf $OUTPUT/orangepi
fi
mkdir $OUTPUT/orangepi
cp -rfa $OUTPUT/uImage $OUTPUT/orangepi
cp -rfa $OUTPUT/OrangePiH5.dtb $OUTPUT/orangepi/OrangePiH5.dtb

# Add boot support if there
if [ -e "$OUTPUT/orangepi/uImage" -a -e "$OUTPUT/orangepi/OrangePiH5orangepi.dtb" ]; then
	mcopy -sm -i ${IMAGE}1 ${OUTPUT}/orangepi ::
	mcopy -m -i ${IMAGE}1 ${OUTPUT}/initrd.img :: || true
	mcopy -m -i ${IMAGE}1 ${OUTPUT}/uEnv.txt :: || true
fi
dd if=${IMAGE}1 conv=notrunc oflag=append bs=1M seek=$((part_position/1024)) of="$IMAGE"
rm -f ${IMAGE}1

# Create additional ext4 file system for rootfs
dd if=/dev/zero bs=1M count=$((disk_size-boot_size-part_position/1024)) of=${IMAGE}2
mkfs.ext4 -F -b 4096 -E stride=2,stripe-width=1024 -L rootfs ${IMAGE}2

if [ ! -d /media/tmp ]; then
	mkdir -p /media/tmp
fi

mount -t ext4 ${IMAGE}2 /media/tmp
# Add rootfs into Image
cp -rfa $OUTPUT/rootfs/* /media/tmp

umount /media/tmp

dd if=${IMAGE}2 conv=notrunc oflag=append bs=1M seek=$((part_position/1024+boot_size)) of="$IMAGE"
rm -f ${IMAGE}2

if [ -d $OUTPUT/orangepi ]; then
	rm -rf $OUTPUT/orangepi
fi 

if [ -d /media/tmp ]; then
	rm -rf /media/tmp
fi

# Add partition table
cat <<EOF | fdisk "$IMAGE"
o
n
p
1
$((part_position*2))
+${boot_size}M
t
c
n
p
2
$((part_position*2 + boot_size*1024*2))

t
2
83
w
EOF

sync
clear
