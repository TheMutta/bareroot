VERSION=6.2
V=6
fetch:
	wget -c https://ftp.gnu.org/pub/gnu/ncurses/ncurses-$(VERSION).tar.gz
	tar -xf ncurses-$(VERSION).tar.gz --no-same-owner
	mv ncurses-$(VERSION)/* .

build:
	./configure --prefix=/ \
		--with-cxx-binding \
	    --with-cxx-shared \
	    --enable-widec \
	    --with-shared
	make

install:
	make install -j`nproc`
	ln -sv libncursesw.so.$(V) $(DESTDIR)/lib/libtinfo.so.$(V)
	ln -sv libncursesw.so.$(V) $(DESTDIR)/lib/libtic.so.$(V)
