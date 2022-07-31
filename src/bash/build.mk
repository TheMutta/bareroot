VERSION=5.1
PROGRAM=bash
fetch:
	wget -c https://ftp.gnu.org/pub/gnu/$(PROGRAM)/$(PROGRAM)-$(VERSION).tar.gz
	tar -xf $(PROGRAM)-$(VERSION).tar.gz --no-same-owner
	mv $(PROGRAM)-$(VERSION)/* .

build:
	./configure --prefix=/ \
	    --with-curses \
	    --enable-readline \
	    --without-bash-malloc
	make

install:
	make install
