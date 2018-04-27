#!/bin/bash -eu

mkdir -p "$CHROOTDIR"
mkdir -p "${CACHEDIR}/output"

mkdir -p "$CHROOTDIR/build/pi-firmware"
mkdir -p "$CHROOTDIR/build/linux-firmware"
mkdir -p "$CHROOTDIR/build/alpine"
mkdir -p "$CHROOTDIR/build/broadcom-wl"
mkdir -p "$CHROOTDIR/build/output"

mount -o bind "${CACHEDIR}/pi-firmware" "$CHROOTDIR/build/pi-firmware"
mount -o bind "${CACHEDIR}/linux-firmware" "$CHROOTDIR/build/linux-firmware"
mount -o bind "${CACHEDIR}/alpine-3.7.0" "$CHROOTDIR/build/alpine"
mount -o bind "${CACHEDIR}/broadcom-wl-4.150.10.5" "$CHROOTDIR/build/broadcom-wl"
mount -o bind "${CACHEDIR}/output" "$CHROOTDIR/build/output"

chroot $CHROOTDIR /build/scripts/build_chroot.sh

umount -l "$CHROOTDIR/build/output"
umount -l "$CHROOTDIR/build/pi-firmware"
umount -l "$CHROOTDIR/build/linux-firmware"
umount -l "$CHROOTDIR/build/alpine"
umount -l "$CHROOTDIR/build/broadcom-wl"

chmod a+rw -R "$CHROOTDIR/build/output"
