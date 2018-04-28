#!/bin/bash -eux

function fetch_git() {
    CACHEFILENAME="${CACHEDIR}/$1.tar.gz"
    WORKDIR="${TRAVIS_BUILD_DIR}/$1"
    if [ -f "${CACHEFILENAME}" ]; then
        mkdir -p "${WORKDIR}"
        tar zxfpC "${CACHEFILENAME}" "${WORKDIR}"
        cd "${WORKDIR}"

        BRANCHNAME=HEAD
        if [ $# -eq 3 ]; then
            BRANCHNAME=$3
        fi
        LATEST_REV=$(git ls-remote origin $BRANCHNAME | awk '{print $1}')
        CURRENT_REV=$(git rev-parse HEAD)
        if [ "$LATEST_REV" != "$CURRENT_REV" ]; then
            git fetch --depth=1
            git merge FETCH_HEAD
            git fetch --depth=1
            git gc
            tar czfpC "${CACHEFILENAME}" "${WORKDIR}" .
        fi
    elif [ $# -eq 2 ]; then
        git clone --depth 1 $2 "${WORKDIR}"
        tar czfpC "${CACHEFILENAME}" "${WORKDIR}" .
    else
        git clone --depth 1 --branch $3 $2 "${WORKDIR}"
        tar czfpC "${CACHEFILENAME}" "${WORKDIR}" .
    fi
    rm -rf "${WORKDIR}"
}

function fetch_file() {
    if [ ! -f "${CACHEDIR}/$1" ]; then
        wget -q -O ${CACHEDIR}/$1 $2
    fi
}

fetch_git u-boot git://git.denx.de/u-boot.git
fetch_git pi-firmware https://github.com/raspberrypi/firmware.git
fetch_git linux-firmware https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
fetch_git kernel https://github.com/raspberrypi/linux.git rpi-4.16.y

fetch_file alpine-uboot-3.7.0-aarch64.tar.gz http://dl-cdn.alpinelinux.org/alpine/v3.7/releases/aarch64/alpine-uboot-3.7.0-aarch64.tar.gz
fetch_file broadcom-wl-4.150.10.5.tar.bz2 http://mirror2.openwrt.org/sources/broadcom-wl-4.150.10.5.tar.bz2
