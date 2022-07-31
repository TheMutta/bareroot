#!/usr/bin/make -f
VERSION=6.03
fetch:
	wget -c http://kernel.org/pub/linux/utils/boot/syslinux/syslinux-$(VERSION).tar.xz
	tar -xf syslinux-$(VERSION).tar.xz --no-same-owner
	mv syslinux-$(VERSION)/* .

build:
	: Do nothing

install:
	cp -vf bios/core/isolinux.bin $(OUTDIR)
	cp -vf bios/com32/elflink/ldlinux/ldlinux.c32 $(OUTDIR)
	cp -vf bios/com32/menu/menu.c32 $(OUTDIR)
	cp -vf bios/com32/libutil/libutil.c32 $(OUTDIR)
	echo 'UI menu.c32' > $(OUTDIR)/isolinux.cfg
	echo 'LABEL linux' >> $(OUTDIR)/isolinux.cfg
	echo '  MENU LABEL Boot the linux kernel' >> $(OUTDIR)/isolinux.cfg
	echo '  KERNEL linux' >> $(OUTDIR)/isolinux.cfg
	echo '  APPEND initrd=initrd.img rdinit=/init' >> $(OUTDIR)/isolinux.cfg
