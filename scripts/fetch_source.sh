#!/bin/bash -eu

if [ -f "${CACHEDIR}/u-boot.tar.gz" ]; then
    tar zxfpC "${CACHEDIR}/u-boot.tar.gz" "${TRAVIS_BUILD_DIR}/u-boot"
    cd "${TRAVIS_BUILD_DIR}/u-boot" && git pull
else
    git clone --depth 1 git://git.denx.de/u-boot.git "${TRAVIS_BUILD_DIR}/u-boot"
fi
tar czfpC "${CACHEDIR}/u-boot.tar.gz" "${TRAVIS_BUILD_DIR}/u-boot" .
rm -rf "${TRAVIS_BUILD_DIR}/u-boot"

if [ -f "${CACHEDIR}/kernel.tar.gz" ]; then
    tar zxfpC "${CACHEDIR}/kernel.tar.gz" "${TRAVIS_BUILD_DIR}/kernel"
    cd "${TRAVIS_BUILD_DIR}/kernel" && git pull
else
    git clone --depth 1 --branch rpi-4.16.y https://github.com/raspberrypi/linux.git "${TRAVIS_BUILD_DIR}/kernel"
fi
tar czfpC "${CACHEDIR}/kernel.tar.gz" "${TRAVIS_BUILD_DIR}/kernel" .
rm -rf "${TRAVIS_BUILD_DIR}/kernel"

if [ -f "${CACHEDIR}/pi-firmware.tar.gz" ]; then
    tar zxfpC "${CACHEDIR}/pi-firmware.tar.gz" "${TRAVIS_BUILD_DIR}/pi-firmware"
    cd "${TRAVIS_BUILD_DIR}/pi-firmware" && git pull
else
    git clone --depth 1 https://github.com/raspberrypi/firmware.git "${TRAVIS_BUILD_DIR}/pi-firmware"
fi
tar czfpC "${CACHEDIR}/pi-firmware.tar.gz" "${TRAVIS_BUILD_DIR}/pi-firmware" .
rm -rf "${TRAVIS_BUILD_DIR}/pi-firmware"

if [ -f "${CACHEDIR}/linux-firmware.tar.gz" ]; then
    tar zxfpC "${CACHEDIR}/linux-firmware.tar.gz" "${TRAVIS_BUILD_DIR}/linux-firmware"
    cd "${TRAVIS_BUILD_DIR}/linux-firmware" && git pull
else
    git clone --depth 1 https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git "${TRAVIS_BUILD_DIR}/linux-firmware"
fi
tar czfpC "${CACHEDIR}/linux-firmware.tar.gz" "${TRAVIS_BUILD_DIR}/linux-firmware" .
rm -rf "${TRAVIS_BUILD_DIR}/linux-firmware"

if [ ! -f "${CACHEDIR}/alpine-uboot-3.7.0-aarch64.tar.gz" ]; then
    wget -q -O ${CACHEDIR}/alpine-uboot-3.7.0-aarch64.tar.gz http://dl-cdn.alpinelinux.org/alpine/v3.7/releases/aarch64/alpine-uboot-3.7.0-aarch64.tar.gz
fi

if [ ! -f "${CACHEDIR}/broadcom-wl-4.150.10.5.tar.bz2" ]; then
    wget -q -O ${CACHEDIR}/broadcom-wl-4.150.10.5.tar.bz2 http://mirror2.openwrt.org/sources/broadcom-wl-4.150.10.5.tar.bz2
fi
