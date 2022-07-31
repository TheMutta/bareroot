#!/bin/bash
set -e
kernel=$(ls work/rootfs/lib/modules/ | sort -V | head -n 1)
mkdir -p work/initramfs/lib/modules/$kernel
for directory in {crypto,fs,lib} \
    drivers/{block,ata,md,firewire} \
    drivers/{scsi,message,pcmcia,virtio} \
    drivers/usb/{host,storage}; do
    mkdir -p work/rootfs/lib/modules/$kernel/kernel/${directory}
    find work/rootfs/lib/modules/$kernel/kernel/${directory}/ -type f \
        -exec install {} work/initramfs/lib/modules/$kernel/ \;
done
depmod --all --basedir=work/initramfs $kernel
cd work/initramfs
chroot . /bin/busybox --install -s /bin
find . -print0 | cpio --null --create --verbose --format=newc > ../out/initrd.img
