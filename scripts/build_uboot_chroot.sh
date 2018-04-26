#!/bin/bash -eu

BUILDDIR=/build
OUTDIR=$BUILDDIR/output

cd $BUILDDIR
git clone --depth 1 git://git.denx.de/u-boot.git u-boot

export CROSS_COMPILE=aarch64-linux-gnu-
export ARCH=arm64
export LOCALVERSION=

cd $BUILDDIR/u-boot
make rpi_3_defconfig && make

mkdir -p $OUTDIR/boot
mv $BUILDDIR/u-boot/u-boot.bin $OUTDIR/boot/

git reset --hard
git clean -df
