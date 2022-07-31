##!/bin/bash
set -e
mksquashfs work/rootfs work/isoimage/root.sqsh -comp xz
cd work/isoimage
xorriso \
  -as mkisofs \
  -o ../../live.iso \
  -b isolinux.bin \
  -c boot.cat \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  ./
