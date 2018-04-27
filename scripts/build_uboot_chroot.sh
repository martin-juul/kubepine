#!/bin/bash -eu

BUILDDIR=/build
OUTDIR=$BUILDDIR/output

export CROSS_COMPILE=aarch64-linux-gnu-
export ARCH=arm64
export LOCALVERSION=

cd $BUILDDIR/u-boot
make rpi_3_defconfig && make

mkdir -p $OUTDIR/boot
mv $BUILDDIR/u-boot/u-boot.bin $OUTDIR/boot/

git reset --hard
git clean -dfx
