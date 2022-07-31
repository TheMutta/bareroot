fetch:
	: Do nothing
build:
	: Do nothing
install:
	mkdir -p $(DESTDIR)/lib $(DESTDIR)/bin || true
	ln -s lib $(DESTDIR)/lib64 || true
	ln -s sbin $(DESTDIR)/libexec || true
	cp -prfv etc $(DESTDIR)
	chmod 600 $(DESTDIR)/etc/shadow
