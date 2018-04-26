#!/bin/bash -eu

umount -l $CHROOTDIR/dev/pts
umount -l $CHROOTDIR/dev
umount -l $CHROOTDIR/sys
umount -l $CHROOTDIR/proc
umount -l $CHROOTDIR/build/scripts
rm -rf $CHROOTDIR
rm -rf $CACHEDIR/output
