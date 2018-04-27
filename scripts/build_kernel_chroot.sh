#!/bin/bash -eu

BUILDDIR=/build
OUTDIR=$BUILDDIR/output

export CROSS_COMPILE="ccache aarch64-linux-gnu-"
export ARCH=arm64
export LOCALVERSION=
export CCACHE_DIR=/ccache

mkdir -p $OUTDIR/kernel
mkdir -p $BUILDDIR/kernel-build
cd $BUILDDIR/kernel
make kernelversion > $OUTDIR/kernel/kernelversion
KERNELVERSION=$(cat $OUTDIR/kernel/kernelversion)
echo KERNELVERSION="$KERNELVERSION"
make O=$BUILDDIR/kernel-build bcmrpi3_defconfig
scripts/kconfig/merge_config.sh -O $BUILDDIR/kernel-build/ $BUILDDIR/kernel-build/.config $BUILDDIR/scripts/config.add
make O=$BUILDDIR/kernel-build -j8

mkdir -p $BUILDDIR/initramfs
make modules_install O=$BUILDDIR/kernel-build INSTALL_MOD_PATH=$BUILDDIR/initramfs/
tar czfpC "$OUTDIR/kernel/initramfs.tar.gz" "$BUILDDIR/initramfs/" .

mv $BUILDDIR/kernel-build/arch/arm64/boot/Image $OUTDIR/kernel/
mv $BUILDDIR/kernel-build/arch/arm64/boot/dts/broadcom/bcm2710-rpi-3-b.dtb $OUTDIR/kernel/
mv $BUILDDIR/kernel-build/arch/arm64/boot/dts/broadcom/bcm2710-rpi-3-b-plus.dtb $OUTDIR/kernel/

rm -rf $BUILDDIR/kernel-build
rm -rf $BUILDDIR/initramfs
