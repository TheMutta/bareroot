##!/bin/bash
set -e
mkdir work/rootimg
dd if=/dev/zero of=root.ext4 bs=4k count=60000
mkfs.ext4 root.ext4
tune2fs -c0 -i0 root.ext4
sudo mount -o loop root.ext4 work/rootimg
sudo cp -vrp work/rootfs/* work/rootimg/
sudo mkdir -p work/rootimg/sys work/rootimg/dev work/rootimg/proc work/rootimg/run work/rootimg/tmp
sudo umount work/rootimg
rm -drf work/rootimg
mv -f root.ext4 work/out
