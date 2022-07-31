#!/bin/sh
set -ex

CORES=15
KERNEL_VERSION=5.17
BUSYBOX_VERSION=1.35.0
SYSLINUX_VERSION=6.03

DROPBEAR_VERSION=2022.82

if [ ! -f "kernel.tar.xz" ]; then
	echo "Downloading the Linux kernel."
	wget -O kernel.tar.xz http://kernel.org/pub/linux/kernel/v5.x/linux-${KERNEL_VERSION}.tar.xz
fi
if [ ! -f "busybox.tar.bz2" ]; then
	echo "Downloading Busybox."
	wget -O busybox.tar.bz2 http://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2
fi
if [ ! -f "syslinux.tar.xz" ]; then
	echo "Downloading Syslinux."
	wget -O syslinux.tar.xz http://kernel.org/pub/linux/utils/boot/syslinux/syslinux-${SYSLINUX_VERSION}.tar.xz
fi
#if [ ! -f "dropbear.tar.bz2" ]; then
#	echo "Downloading DropbearSSH."
#	wget -O dropbear.tar.bz2 https://matt.ucc.asn.au/dropbear/releases/dropbear-${DROPBEAR_VERSION}.tar.bz2
#fi

tar -xvf kernel.tar.xz
tar -xvf busybox.tar.bz2
tar -xvf syslinux.tar.xz
#tar -xvf dropbear.tar.bz2
mkdir isoimage

cd busybox-${BUSYBOX_VERSION}
make distclean defconfig
sed -i "s/^.*CONFIG_STATIC[^_].*$/CONFIG_STATIC=y/g" .config
make CC=musl-gcc -j${CORES} busybox install
cd _install

rm -f linuxrc
mkdir dev proc sys etc mnt tmp
cd ..

cp -rfv _install ../ramfs

#cd ../dropbear-${DROPBEAR_VERSION}
#./configure --prefix=/ --enable-static --disable-zlib CC=musl-gcc LD=musl-gcc
#make -j${CORES}
#make DESTDIR=../ramfs install

cd ../ramfs

mkdir etc/init.d lib
ln -sf bin/busybox bin/init
ln -sf bin/busybox init

echo 'root:x:0:0::/:/bin/sh' > etc/passwd
echo 'root:x:0:root' > etc/group
echo 'root::3ZD.JakwBsaYU:0:99999:7:::' > etc/shadow

echo '#!/bin/sh' > etc/init.d/rcS
echo '/bin/dmesg -n 1' >> etc/init.d/rcS
echo '/bin/mount -t devtmpfs none /dev' >> etc/init.d/rcS
echo '/bin/mount -t proc none /proc' >> etc/init.d/rcS
echo '/bin/mount -t sysfs none /sys' >> etc/init.d/rcS
chmod +x etc/init.d/rcS

echo '::sysinit:/etc/init.d/rcS' > etc/inittab
#echo 'tty1::askfirst:/sbin/getty 9600 tty1' >> etc/inittab
#echo 'tty2::askfirst:/sbin/getty 9600 tty2' >> etc/inittab
echo '::askfirst:-/bin/sh' >> etc/inittab
echo '::restart:/sbin/init' >> etc/inittab
echo '::ctrlaltdel:/sbin/reboot' >> etc/inittab
echo '::shutdown:/bin/umount -a -r' >> etc/inittab
echo '::shutdown:/sbin/swapoff -a' >> etc/inittab

find . | cpio -R root:root -H newc -o | gzip > ../isoimage/ramfs.gz

cd ../linux-${KERNEL_VERSION}
make -j${CORES} mrproper
cp -f ../kconfig.x86_64 .config
make -j${CORES} all
cp arch/x86/boot/bzImage ../isoimage/kernel.gz

cd ../isoimage
cp -vf ../syslinux-${SYSLINUX_VERSION}/bios/core/isolinux.bin .
cp -vf ../syslinux-${SYSLINUX_VERSION}/bios/com32/elflink/ldlinux/ldlinux.c32 .
cp -vf ../syslinux-${SYSLINUX_VERSION}/bios/com32/menu/menu.c32 .
cp -vf ../syslinux-${SYSLINUX_VERSION}/bios/com32/libutil/libutil.c32 .
echo 'UI menu.c32' > ./isolinux.cfg
echo 'LABEL linux' >> ./isolinux.cfg
echo '  MENU LABEL Boot the linux kernel' >> ./isolinux.cfg
echo '  KERNEL kernel.gz' >> ./isolinux.cfg
echo '  APPEND initrd=ramfs.gz rdinit=/init' >> ./isolinux.cfg

rm -drf ../*.iso

xorriso \
  -as mkisofs \
  -o ../minimal_linux_live.iso \
  -b isolinux.bin \
  -c boot.cat \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  ./

cd ..
set +ex
