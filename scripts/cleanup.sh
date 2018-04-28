#!/bin/bash -eu

umount -l $CHROOTDIR/dev/pts || true
umount -l $CHROOTDIR/dev || true
umount -l $CHROOTDIR/sys || true
umount -l $CHROOTDIR/proc || true
umount -l $CHROOTDIR/ccache || true
umount -l $CHROOTDIR/build/scripts || true

rm -rf $CHROOTDIR
rm -rf $CACHEDIR/output
