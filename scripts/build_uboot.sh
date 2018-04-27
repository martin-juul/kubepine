#!/bin/bash -eu

mkdir -p "$CHROOTDIR"
mkdir -p ${CACHEDIR}/output

if [ -d "${CACHEDIR}/u-boot" ]; then
    cd "${CACHEDIR}/u-boot" && git pull
else
    git clone --depth 1 git://git.denx.de/u-boot.git "${CACHEDIR}/u-boot"
fi

mkdir -p "$CHROOTDIR/build/u-boot"
mkdir -p "$CHROOTDIR/build/output"
mount -o bind "${CACHEDIR}/u-boot" "$CHROOTDIR/build/u-boot"
mount -o bind "${CACHEDIR}/output" "$CHROOTDIR/build/output"

chroot $CHROOTDIR /build/scripts/build_uboot_chroot.sh

umount -l "$CHROOTDIR/build/output"
umount -l "$CHROOTDIR/build/u-boot"

chmod a+rw -R "$CHROOTDIR/build/output"
