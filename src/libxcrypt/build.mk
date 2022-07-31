VERSION=4.4.28
fetch:
	wget -c https://github.com/besser82/libxcrypt/releases/download/v$(VERSION)/libxcrypt-$(VERSION).tar.xz
	tar -xf libxcrypt-$(VERSION).tar.xz --no-same-owner
	mv libxcrypt-$(VERSION)/* .

build:
	autoreconf -fiv
	./configure --prefix=/ \
	    --enable-hashes=strong,glibc \
	    --enable-obsolete-api=no \
	    --disable-failure-tokens
	make -j`nproc`

install:
	make install -j`nproc`
