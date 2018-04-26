#!/bin/bash -eu

export BUILDDIR=/build

apt-add-repository universe
apt-add-repository multiverse
apt-get update
apt-get -y install gcc-aarch64-linux-gnu git make gcc bc device-tree-compiler u-boot-tools \
  ncurses-dev qemu-user-static wget cpio kmod squashfs-tools bison flex libssl-dev patch \
  xz-utils b43-fwcutter bzip2

mkdir -p $BUILDDIR/alpine
mkdir -p $BUILDDIR/kernel-build
mkdir -p $BUILDDIR/initramfs
mkdir -p $BUILDDIR/modloop
mkdir -p $BUILDDIR/b43

cd $BUILDDIR
git clone --depth 1 --branch rpi-4.16.y https://github.com/raspberrypi/linux.git kernel
git clone --depth 1 https://github.com/raspberrypi/firmware.git pi-firmware
git clone --depth 1 https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git linux-firmware
git clone --depth 1 git://git.denx.de/u-boot.git u-boot
wget -q http://dl-cdn.alpinelinux.org/alpine/v3.7/releases/aarch64/alpine-uboot-3.7.0-aarch64.tar.gz
wget -q http://mirror2.openwrt.org/sources/broadcom-wl-4.150.10.5.tar.bz2
cd $BUILDDIR/alpine && tar zxf $BUILDDIR/alpine-uboot-3.7.0-aarch64.tar.gz
cd $BUILDDIR/initramfs && gunzip -c $BUILDDIR/alpine/boot/initramfs-vanilla | cpio -i

export CROSS_COMPILE=aarch64-linux-gnu-
export ARCH=arm64
export LOCALVERSION=

cd $BUILDDIR/u-boot
make rpi_3_defconfig && make

cd $BUILDDIR/kernel
make O=$BUILDDIR/kernel-build bcmrpi3_defconfig
scripts/kconfig/merge_config.sh -O $BUILDDIR/kernel-build/ $BUILDDIR/kernel-build/.config $BUILDDIR/scripts/config.add
make O=$BUILDDIR/kernel-build -j8
make kernelversion > $BUILDDIR/kernelversion
export KERNELVERSION=`cat $BUILDDIR/kernelversion`
rm -rf $BUILDDIR/initramfs/lib/modules/4.*
make modules_install O=$BUILDDIR/kernel-build INSTALL_MOD_PATH=$BUILDDIR/initramfs/
cd $BUILDDIR/initramfs && find . | cpio -H newc -o | gzip -9 > $BUILDDIR/initramfs-rpi3-cpio
cd $BUILDDIR && mkimage -A arm64 -O linux -T ramdisk -d initramfs-rpi3-cpio initramfs-rpi3
mkdir -p $BUILDDIR/modloop/lib/firmware
cd $BUILDDIR/linux-firmware && DESTDIR=$BUILDDIR/modloop make install
cd $BUILDDIR/b43 && tar xjf $BUILDDIR/broadcom-wl-4.150.10.5.tar.bz2 --strip=1
b43-fwcutter -w $BUILDDIR/modloop/lib/firmware $BUILDDIR/b43/driver/wl_apsta_mimo.o
mkimage -A arm64 -O linux -T script -C none -a 0 -e 0 -n "raspberry-pi" -d $BUILDDIR/scripts/boot.txt $BUILDDIR/boot.scr
cp -R $BUILDDIR/initramfs/lib/modules $BUILDDIR/modloop/lib/
mksquashfs $BUILDDIR/modloop/lib/ $BUILDDIR/modloop-rpi3 -comp xz -Xdict-size 100%

mkdir -p $BUILDDIR/output/boot
mkdir -p $BUILDDIR/output/firmware
cp $BUILDDIR/kernel-build/arch/arm64/boot/Image $BUILDDIR/output/boot/Image
cp $BUILDDIR/kernel-build/arch/arm64/boot/dts/broadcom/bcm2710-rpi-3-b.dtb $BUILDDIR/output/
cp $BUILDDIR/kernel-build/arch/arm64/boot/dts/broadcom/bcm2710-rpi-3-b-plus.dtb $BUILDDIR/output/
cp $BUILDDIR/initramfs-rpi3 $BUILDDIR/output/boot/
cp $BUILDDIR/modloop-rpi3 $BUILDDIR/output/boot/
cp $BUILDDIR/boot.scr $BUILDDIR/output/boot/
cp $BUILDDIR/pi-firmware/boot/bootcode.bin $BUILDDIR/output/
cp $BUILDDIR/pi-firmware/boot/start.elf $BUILDDIR/output/
cp $BUILDDIR/pi-firmware/boot/fixup.dat $BUILDDIR/output/
cp $BUILDDIR/pi-firmware/boot/start_cd.elf $BUILDDIR/output/
cp $BUILDDIR/pi-firmware/boot/fixup_cd.dat $BUILDDIR/output/
cp $BUILDDIR/pi-firmware/boot/start_x.elf $BUILDDIR/output/
cp $BUILDDIR/pi-firmware/boot/fixup_x.dat $BUILDDIR/output/
cp $BUILDDIR/pi-firmware/boot/start_db.elf $BUILDDIR/output/
cp $BUILDDIR/pi-firmware/boot/fixup_db.dat $BUILDDIR/output/
cp $BUILDDIR/pi-firmware/boot/bcm2710-rpi-cm3.dtb $BUILDDIR/output/
cp $BUILDDIR/alpine/alpine.apkovl.tar.gz $BUILDDIR/output/
cp -R $BUILDDIR/alpine/apks $BUILDDIR/output/
cp -R $BUILDDIR/modloop/lib/firmware/brcm $BUILDDIR/output/firmware
cp -R $BUILDDIR/modloop/lib/firmware/b43 $BUILDDIR/output/firmware
cp $BUILDDIR/u-boot/u-boot.bin $BUILDDIR/output/boot/
cp $BUILDDIR/scripts/config.txt $BUILDDIR/output/
cp $BUILDDIR/scripts/cmdline.txt $BUILDDIR/output/
cd $BUILDDIR/output && tar Jcf $BUILDDIR/alpine-rpi-3.7.0-aarch64-$KERNELVERSION.tar.xz .
