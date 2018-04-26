#!/bin/bash -eu

mkdir -p "$CHROOTDIR"

if [ -d "${CACHEDIR}/u-boot" ]; then
    git clone --depth 1 git://git.denx.de/u-boot.git "${CACHEDIR}/u-boot"
else
    cd "${CACHEDIR}/u-boot" && git pull
fi

mkdir -p "$CHROOTDIR/build/u-boot"
mkdir -p "$CHROOTDIR/build/output"
mount -o bind "${CACHEDIR}/u-boot" "$CHROOTDIR/build/u-boot"
mount -o bind "${CACHEDIR}/output" "$CHROOTDIR/build/output"

chroot $CHROOTDIR $CHROOTDIR/build/scripts/build_uboot_chroot.sh

umount -l "$CHROOTDIR/build/output"
umount -l "$CHROOTDIR/build/u-boot"

chmod a+rw -R "$CHROOTDIR/build/u-boot"
chmod a+rw -R "$CHROOTDIR/build/output"
