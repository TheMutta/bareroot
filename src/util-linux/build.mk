VERSION=2.38
fetch:
	wget -c https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v$(VERSION)/util-linux-$(VERSION).tar.xz
	tar -xf util-linux-$(VERSION).tar.xz --no-same-owner
	mv util-linux-$(VERSION)/* .

build:
	autoreconf -fvi
	./configure --prefix=/ \
	    --disable-makeinstall-chown \
	    --disable-su \
	    --disable-runuser \
	    --disable-login \
	    --disable-nologin \
	    --disable-sulogin
	    
	make -j`nproc`
install:
	make install -j`nproc` DESTDIR=$(DESTDIR)/util-linux
	cp -prfv $(DESTDIR)/util-linux/* $(DESTDIR)/
	rm -rf $(DESTDIR)/util-linux
