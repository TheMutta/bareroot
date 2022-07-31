VERSION=1.35.0
fetch:
	wget -c https://busybox.net/downloads/busybox-$(VERSION).tar.bz2
	tar -xf busybox-$(VERSION).tar.bz2
	mv busybox-$(VERSION)/* .

build:
	make defconfig
	sed -i "s|.*CONFIG_STATIC_LIBGCC .*|CONFIG_STATIC_LIBGCC=y|" .config
	sed -i "s|.*CONFIG_STATIC .*|CONFIG_STATIC=y|" .config
	make -j`nproc`

install:
	mkdir -p $(DESTDIR)/bin $(INITRAMFS)/bin
	install busybox $(DESTDIR)/bin/busybox
	install busybox $(INITRAMFS)/bin/busybox
	chroot $(DESTDIR) /bin/busybox --install -s /bin
	install initramfs-init $(INITRAMFS)/init
