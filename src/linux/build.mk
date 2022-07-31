#!/usr/bin/make -f
VERSION=5.18
fetch:
	wget -c https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-$(VERSION).tar.xz
	tar -xf linux-$(VERSION).tar.xz
	mv linux-$(VERSION)/* .

build:
	cat kconfig.x86_64 > .config
	make olddefconfig bzImage modules -j`nproc`

install:
	mkdir -p $(DESTDIR)/lib/modules $(DESTDIR)/boot/
	install arch/x86/boot/bzImage $(DESTDIR)/boot/vmlinuz-$(VERSION)
	install arch/x86/boot/bzImage $(OUTDIR)/linux
	make modules_install INSTALL_MOD_PATH=$(DESTDIR) -j`nproc`
	
