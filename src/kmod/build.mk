VERSION=29
fetch:
	wget -c https://mirrors.edge.kernel.org/pub/linux/utils/kernel/kmod/kmod-$(VERSION).tar.xz
	tar -xf kmod-$(VERSION).tar.xz --no-same-owner
	mv kmod-$(VERSION)/* .

build:
	autoreconf -fiv
	./configure --prefix=/
	make -j`nproc`

install:
	make install -j`nproc`
