fetch:
	wget -c https://github.com/eudev-project/eudev/archive/refs/heads/master.zip
	unzip master.zip
	mv eudev-master/* .

build:
	autoreconf -fvi
	./configure --prefix=/
	make -j`nproc`

install:
	make install -j`nproc`
