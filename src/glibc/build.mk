VERSION=2.35
fetch:
	wget -c https://ftp.gnu.org/gnu/glibc/glibc-$(VERSION).tar.xz
	tar -xf glibc-$(VERSION).tar.xz
	mv glibc-$(VERSION)/* .
build:
	mkdir glibc-build -p
	cd glibc-build && ../configure \
	    --prefix=/ \
	    --disable-profile \
	    --disable-crypt \
	    --disable-werror
	cd glibc-build && make -j`nproc`

install:
	cd glibc-build && make install -j`nproc`
