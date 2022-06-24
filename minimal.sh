#!/bin/sh
set -ex

CORES=15
KERNEL_VERSION=5.17
BUSYBOX_VERSION=1.35.0
SYSLINUX_VERSION=6.03

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
if [ ! -f "x86_64-linux-musl-native.tgz" ]; then
	echo "Downloading Musl."
	wget -O x86_64-linux-musl-native.tgz https://musl.cc/x86_64-linux-musl-native.tgz
fi


tar -xvf kernel.tar.xz
tar -xvf busybox.tar.bz2
tar -xvf syslinux.tar.xz
tar -xvf x86_64-linux-musl-native.tgz
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
cp -rfv _install ../rootfs

cd ../ramfs

mkdir newroot
echo '#!/bin/sh' > init
echo 'dmesg -n 6' >> init
echo 'mount -t devtmpfs none /dev' >> init
echo 'mount -t proc none /proc' >> init
echo 'mount -t sysfs none /sys' >> init
echo 'mount /dev/sr0 /mnt' >> init
echo 'mount /mnt/live/rootfs.sqsh /newroot' >> init

echo 'exec switch_root /newroot /init' >> init
echo 'sedsid cttyhack /bin/sh' >> init # We should never get here
chmod +x init

find . | cpio -R root:root -H newc -o | gzip > ../isoimage/ramfs.gz

cd ../rootfs/usr
mv -fv ../../x86_64-linux-musl-native .
mv -fv ./x86_64-linux-musl-native/bin/* bin/
rm -drf ./x86_64-linux-musl-native/bin
mv -fv ./x86_64-linux-musl-native/* .
rm -drf ./x86_64-linux-musl-native
cd ..

ln -sf bin/busybox bin/init
ln -sf bin/busybox init
ln -sf usr/lib lib
echo 'root:x:0:0::/:/bin/sh' > etc/passwd
echo 'root:x:0:root' > etc/group
echo 'root::$1$v9g8bFoY$aNvBpSVHKf4jGiqtwj.vr0:0:99999:7:::' > etc/shadow

echo '::sysinit:/bin/dmesg -n 4' > etc/inittab
echo '::sysinit:/bin/mount -t devtmpfs none /dev' >> etc/inittab
echo '::sysinit:/bin/mount -t proc none /proc' >> etc/inittab
echo '::sysinit:/bin/mount -t sysfs none /sys' >> etc/inittab
echo '::sysinit:/bin/mount -t tmpfs -o size=20m tmpfs /tmp' >> etc/inittab
echo 'tty1::respawn:/sbin/getty 9600 tty1' >> etc/inittab
echo 'tty2::respawn:/sbin/getty 9600 tty2' >> etc/inittab
echo 'tty3::respawn:/sbin/getty 9600 tty3' >> etc/inittab
echo 'tty4::respawn:/sbin/getty 9600 tty4' >> etc/inittab
echo 'tty5::respawn:/sbin/getty 9600 tty5' >> etc/inittab
echo 'tty6::respawn:/sbin/getty 9600 tty6' >> etc/inittab
echo '::restart:/sbin/init' >> etc/inittab
echo '::ctrlaltdel:/sbin/reboot' >> etc/inittab
echo '::shutdown:/bin/umount -a -r' >> etc/inittab
echo '::shutdown:/sbin/swapoff -a' >> etc/inittab
chmod +x etc/inittab

mkdir ../isoimage/live
mksquashfs * ../isoimage/live/rootfs.sqsh

cd ../linux-${KERNEL_VERSION}
make CC=musl-gcc -j${CORES} mrproper defconfig
cp -fv ../kconfig .config
make CC=musl-gcc -j${CORES} bzImage
cp arch/x86/boot/bzImage ../isoimage/kernel.gz

cd ../isoimage
cp -vf ../syslinux-${SYSLINUX_VERSION}/bios/core/isolinux.bin .
cp -vf ../syslinux-${SYSLINUX_VERSION}/bios/com32/elflink/ldlinux/ldlinux.c32 .
echo 'default kernel.gz initrd=ramfs.gz' > ./isolinux.cfg

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
