VERSION=1.2.12
fetch:
	wget -c https://www.zlib.net/zlib-$(VERSION).tar.gz
	tar -xf zlib-$(VERSION).tar.gz --no-same-owner
	mv zlib-$(VERSION)/* .
build:
	./configure --prefix=/
	make -j`nproc`
install:
	make install -j`nproc`
