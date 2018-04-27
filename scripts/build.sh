#!/bin/bash -eu

mkdir -p "$CHROOTDIR"
mkdir -p "${CACHEDIR}/output"

if [ -d "${CACHEDIR}/pi-firmware" ]; then
    cd "${CACHEDIR}/pi-firmware" && git pull
else
    git clone --depth 1 https://github.com/raspberrypi/firmware.git "${CACHEDIR}/pi-firmware"
fi

if [ -d "${CACHEDIR}/linux-firmware" ]; then
    cd "${CACHEDIR}/linux-firmware" && git pull
else
    git clone --depth 1 https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git "${CACHEDIR}/linux-firmware"
fi

if [ ! -d "${CACHEDIR}/alpine-3.7.0" ]; then
    rm -rf "${CACHEDIR}/alpine-*"
    mkdir -p "${CACHEDIR}/alpine-3.7.0"
    wget -O - http://dl-cdn.alpinelinux.org/alpine/v3.7/releases/aarch64/alpine-uboot-3.7.0-aarch64.tar.gz | tar zxfC - "${CACHEDIR}/alpine-3.7.0"
fi

if [ ! -d "${CACHEDIR}/broadcom-wl-4.150.10.5" ]; then
    rm -rf "${CACHEDIR}/broadcom-wl-*"
    mkdir -p "${CACHEDIR}/broadcom-wl-4.150.10.5"
    wget -O - http://mirror2.openwrt.org/sources/broadcom-wl-4.150.10.5.tar.bz2 | tar zxfC - "${CACHEDIR}/broadcom-wl-4.150.10.5" --strip=1
fi

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
