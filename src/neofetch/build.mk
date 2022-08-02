fetch:
	: Do nothing
build:
	: Do nothing
install:
	cp -prfv neofetch $(DESTDIR)/bin
	chmod 555 $(DESTDIR)/bin/neofetch
