UDEVDIR     = $(DESTDIR)/etc/udev/rules.d
BINDIR      = $(DESTDIR)/usr/bin
UDEVRULE    = 99-batify.rules
XPUB        = xpub/src/xpub.sh

$(XPUB):
	$(error xpub: submodule not found.)

install: $(XPUB)
	mkdir  -p $(UDEVDIR)
	mkdir -p $(BINDIR)
	chmod 644 $(UDEVRULE)
	chmod 755 $(XPUB)
	cp $(UDEVRULE) $(UDEVDIR)/$(UDEVRULE)
	cp $(XPUB) $(BINDIR)/xpub

uninstall:
	$(RM) $(UDEVDIR)/$(UDEVRULE) $(BINDIR)/xpub

.PHONY: install uninstall
