fetch:
	wget -c https://github.com/mkj/dropbear/archive/refs/heads/master.zip
	unzip master.zip
	mv dropbear-master/* .

build:
	./configure --prefix=/
	make -j`nproc`

install:
	make install -j`nproc`
