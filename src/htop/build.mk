VERSION=3.2.1
fetch:
	wget -c https://github.com/htop-dev/htop/releases/download/$(VERSION)/htop-$(VERSION).tar.xz
	tar -xf htop-$(VERSION).tar.xz --no-same-owner
	mv htop-$(VERSION)/* .

build:
	./configure --prefix=/ \
	    --enable-affinity \
	    --disable-sensors \
	    --disable-capabilities \
	    --disable-delayacct \
	    --disable-affinity \
	    --disable-unwind
	make -j`nproc`

install:
	make install
