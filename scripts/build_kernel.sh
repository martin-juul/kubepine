#!/bin/bash -eu

mkdir -p "$CHROOTDIR"
mkdir -p "${CACHEDIR}/output"

if [ -d "${CACHEDIR}/kernel" ]; then
    cd "${CACHEDIR}/kernel" && git pull
else
    git clone --depth 1 --branch rpi-4.16.y https://github.com/raspberrypi/linux.git "${CACHEDIR}/kernel"
fi

mkdir -p "$CHROOTDIR/build/kernel"
mkdir -p "$CHROOTDIR/build/output"
mount -o bind "${CACHEDIR}/kernel" "$CHROOTDIR/build/kernel"
mount -o bind "${CACHEDIR}/output" "$CHROOTDIR/build/output"

chroot $CHROOTDIR /build/scripts/build_kernel_chroot.sh

umount -l "$CHROOTDIR/build/output"
umount -l "$CHROOTDIR/build/kernel"

chmod a+rw -R "$CHROOTDIR/build/output"
