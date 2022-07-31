##!/bin/bash
set -e
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
