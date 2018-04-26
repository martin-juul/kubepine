#!/bin/bash -eu

cd "$CHROOTDIR"
echo CurrentDirectory: "$(pwd)"
debootstrap --arch amd64 --variant=buildd --no-check-gpg --include=software-properties-common,sudo bionic . http://mirror.genesisadaptive.com/ubuntu/
mkdir -p "$CHROOTDIR/build"
cp -R "$TRAVIS_BUILD_DIR/scripts" "$CHROOTDIR/build/"
mount -t sysfs sysfs "$CHROOTDIR/sys/"
mount -t proc proc "$CHROOTDIR/proc/"
mount -o bind /dev "$CHROOTDIR/dev/"
mount -o bind /dev/pts "$CHROOTDIR/dev/pts"
