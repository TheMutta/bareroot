fetch:
	wget -c https://gitlab.com/tearch-linux/applications-and-tools/31init/-/archive/master/31init-master.zip
	unzip 31init-master.zip
	mv 31init-master/* .
build:
	make
install:
	make install
