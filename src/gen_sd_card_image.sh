#!/bin/sh

FILE=sdcard.img
UBOOT_DIR=u-boot
export MTOOLSRC=config.mtools

echo "Create empty image file"
dd if=/dev/zero of=$FILE bs=128k count=535

cat << EOF > config.mtools 
drive i:
    file="./$FILE"
    partition=1
    cylinders=8
    heads=255
    sectors=63
    mformat_only
EOF

echo "Creating boot partition on image"
mpartition -cI -T 0xc I:
echo "Formatting boot partition as FAT32"
mformat -L 32 I:

echo "Creating haiku_loader_nbsd.ub"
mkimage -A arm -O netbsd -T multi -C none -a 0x80008000 -e 0x80008008 -n 'haiku_loader beagle' -d ../objects/haiku/arm/release/system/boot/haiku_loader $UBOOT_DIR/haiku_loader_nbsd.ub

echo "Copying u-boot files to image"
mcopy $UBOOT_DIR/* I:

echo "Appending haiku-bootstrap.image to image file"
dd if=../haiku-bootstrap.image of=$FILE bs=1M count=328 conv=notrunc oflag=append

echo "Deleting config.mtools"
rm config.mtools

echo "Deleting haiku_loader_nbsd.ub"
rm $UBOOT_DIR/haiku_loader_nbsd.ub

echo "Running qemu"
qemu-system-arm -M beaglexm -drive if=sd,file=./$FILE -clock unix -serial stdio -s
