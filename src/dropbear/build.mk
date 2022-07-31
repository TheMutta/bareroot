fetch:
	wget -c https://github.com/mkj/dropbear/archive/refs/heads/master.zip
	unzip master.zip
	mv dropbear-master/* .

build:
	./configure --prefix=/
	make -j`nproc`

install:
	make install -j`nproc`
	install 50-dropbear $(DESTDIR)/etc/31.d/
