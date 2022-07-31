#!/usr/bin/make -f
VERSION=6.03
fetch:
	wget -c http://kernel.org/pub/linux/utils/boot/syslinux/syslinux-$(VERSION).tar.xz
	tar -xf syslinux-$(VERSION).tar.xz --no-same-owner
	mv syslinux-$(VERSION)/* .

build:
	: Do nothing

install:
	cp -vf bios/core/isolinux.bin $(ISOWORK)
	cp -vf bios/com32/elflink/ldlinux/ldlinux.c32 $(ISOWORK)
	cp -vf bios/com32/menu/menu.c32 $(ISOWORK)
	cp -vf bios/com32/libutil/libutil.c32 $(ISOWORK)
	echo 'UI menu.c32' > $(ISOWORK)/isolinux.cfg
	echo 'LABEL linux' >> $(ISOWORK)/isolinux.cfg
	echo '  MENU LABEL Boot the linux kernel' >> $(ISOWORK)/isolinux.cfg
	echo '  KERNEL linux' >> $(ISOWORK)/isolinux.cfg
	echo '  APPEND initrd=initrd.img rdinit=/init' >> $(ISOWORK)/isolinux.cfg
