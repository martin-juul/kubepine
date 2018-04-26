#!/bin/bash -eu

apt-add-repository universe
apt-add-repository multiverse
apt-get -yq update
apt-get -yq install gcc-aarch64-linux-gnu git make gcc bc device-tree-compiler u-boot-tools \
  ncurses-dev qemu-user-static wget cpio kmod squashfs-tools bison flex libssl-dev patch \
  xz-utils b43-fwcutter bzip2 ccache
apt-get clean
