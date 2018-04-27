#!/bin/bash -eu

mkdir -p "$CHROOTDIR"
mkdir -p ${CACHEDIR}/output

mkdir -p "${TRAVIS_BUILD_DIR}/u-boot"
tar zxfpC "${CACHEDIR}/u-boot.tar.gz" "${TRAVIS_BUILD_DIR}/u-boot"

mkdir -p "$CHROOTDIR/build/u-boot"
mkdir -p "$CHROOTDIR/build/output"
mount -o bind "${TRAVIS_BUILD_DIR}/u-boot" "$CHROOTDIR/build/u-boot"
mount -o bind "${CACHEDIR}/output" "$CHROOTDIR/build/output"

chroot $CHROOTDIR /build/scripts/build_uboot_chroot.sh

umount -l "$CHROOTDIR/build/output"
umount -l "$CHROOTDIR/build/u-boot"

rm -rf "${TRAVIS_BUILD_DIR}/u-boot"

chmod a+rw -R "$CHROOTDIR/build/output"
