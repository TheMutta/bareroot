VERSION=8.1
fetch:
	wget -c https://ftp.gnu.org/pub/gnu/readline/readline-$(VERSION).tar.gz
	tar -xf readline-$(VERSION).tar.gz --no-same-owner
	mv readline-$(VERSION)/* .

build:
	./configure --prefix=/
	make -j`nproc`
install:
	make install -j`nproc`
