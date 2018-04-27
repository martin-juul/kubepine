#!/bin/bash -eu

mkdir -p "$CHROOTDIR"
mkdir -p "${CACHEDIR}/output"

mkdir -p "$CHROOTDIR/build/kernel"
mkdir -p "$CHROOTDIR/build/output"

tar zxfpC "${CACHEDIR}/kernel.tar.gz" "${TRAVIS_BUILD_DIR}/kernel"

mount -o bind "${TRAVIS_BUILD_DIR}/kernel" "$CHROOTDIR/build/kernel"
mount -o bind "${CACHEDIR}/output" "$CHROOTDIR/build/output"

chroot $CHROOTDIR /build/scripts/build_kernel_chroot.sh

umount -l "$CHROOTDIR/build/output"
umount -l "$CHROOTDIR/build/kernel"

rm -rf "${TRAVIS_BUILD_DIR}/kernel"

chmod a+rw -R "$CHROOTDIR/build/output"
