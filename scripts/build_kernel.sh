#!/bin/bash -eu

mkdir -p "$CHROOTDIR"
mkdir -p "${CACHEDIR}/output"

mkdir -p "$CHROOTDIR/build/kernel"
mkdir -p "$CHROOTDIR/build/output"

mount -o bind "${CACHEDIR}/kernel" "$CHROOTDIR/build/kernel"
mount -o bind "${CACHEDIR}/output" "$CHROOTDIR/build/output"

chroot $CHROOTDIR /build/scripts/build_kernel_chroot.sh

umount -l "$CHROOTDIR/build/output"
umount -l "$CHROOTDIR/build/kernel"

chmod a+rw -R "$CHROOTDIR/build/output"
