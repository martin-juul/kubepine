#!/bin/bash -eu

if [ -d "${CACHEDIR}/u-boot" ]; then
    cd "${CACHEDIR}/u-boot" && git pull
else
    git clone --depth 1 git://git.denx.de/u-boot.git "${CACHEDIR}/u-boot"
fi

if [ -d "${CACHEDIR}/kernel" ]; then
    cd "${CACHEDIR}/kernel" && git pull
else
    git clone --depth 1 --branch rpi-4.16.y https://github.com/raspberrypi/linux.git "${CACHEDIR}/kernel"
fi

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
