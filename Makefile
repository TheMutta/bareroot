all: build-x86_64

build-x86_64:
	unshare -ru bash tools/build-x86_64.sh
	unshare -ru bash tools/mkinitrd-x86_64.sh
	unshare -ru bash tools/mkiso-x86_64.sh

rebuild-x86_64:
	rm -fvr work/*/.build
	make build-x86_64

reinstall-x86_64:
	rm -fvr work/*/.install work/rootfs/ work/isowork work/initramfs
	make build

qemu-x86_64:
	qemu-system-x86_64 -m 64M -cdrom live.iso -boot d -vga std -enable-kvm

clean:
	rm -rf work
	rm -rf *.iso