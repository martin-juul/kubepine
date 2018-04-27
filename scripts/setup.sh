#!/bin/bash -eu

mkdir -p "$CHROOTDIR"

if [ -r "${CACHEDIR}/chroot.tar.gz" ]; then
    tar zxfpC "${CACHEDIR}/chroot.tar.gz" "$CHROOTDIR"
else
    apt-get -yq update
    apt-get -yq install debootstrap dchroot apt dpkg dpkg-dev debianutils debconf binutils fakeroot

    cd "$CHROOTDIR"
    debootstrap --arch amd64 --variant=buildd --no-check-gpg --include=software-properties-common,sudo bionic . http://mirror.genesisadaptive.com/ubuntu/
    mkdir -p "$CHROOTDIR/build/scripts"

    mount -o bind "$TRAVIS_BUILD_DIR/scripts" "$CHROOTDIR/build/scripts"
    mount -t sysfs sysfs "$CHROOTDIR/sys/"
    mount -t proc proc "$CHROOTDIR/proc/"
    mount -o bind /dev "$CHROOTDIR/dev/"
    mount -o bind /dev/pts "$CHROOTDIR/dev/pts"

    chmod a+x $CHROOTDIR/build/scripts/setup_chroot.sh
    chroot $CHROOTDIR /build/scripts/setup_chroot.sh

    umount -l $CHROOTDIR/dev/pts
    umount -l $CHROOTDIR/dev
    umount -l $CHROOTDIR/sys
    umount -l $CHROOTDIR/proc
    umount -l $CHROOTDIR/build/scripts

    tar czfpC "${CACHEDIR}/chroot.tar.gz" "$CHROOTDIR" .
fi

mount -o bind "$TRAVIS_BUILD_DIR/scripts" "$CHROOTDIR/build/scripts"
mount -t sysfs sysfs "$CHROOTDIR/sys/"
mount -t proc proc "$CHROOTDIR/proc/"
mount -o bind /dev "$CHROOTDIR/dev/"
mount -o bind /dev/pts "$CHROOTDIR/dev/pts"
