SHELL := /bin/bash

UDEVDIR = $(DESTDIR)/etc/udev/rules.d
BINDIR  = $(DESTDIR)/usr/local/bin
ICONDIR = $(DESTDIR)/usr/share/icons

SRC  = src/batify.sh
UDEV = 99-$(shell basename $(basename $(SRC))).rules

all:$(UDEV)

$(UDEV):
	@echo -e 'ACTION=="change", KERNEL=="BAT0", \\' >  $(UDEV)
	@echo -e 'SUBSYSTEM=="power_supply", \\'        >> $(UDEV)
	@echo -e 'ATTR{status}=="Discharging", \\'      >> $(UDEV)
	@echo -n 'RUN+="/usr/bin/su $(USER) -c '        >> $(UDEV)
	@echo -e ''\''/usr/local/bin/batify.sh %k $$attr{capacity}'\''"' >> $(UDEV)

install: all
	mkdir -p $(UDEVDIR)
	mkdir -p $(ICONDIR)
	mkdir -p $(BINDIR)
	cp $(UDEV) $(UDEVDIR)
	cp -r icons $(ICONDIR)/batify
	cp $(SRC) $(BINDIR)/$(shell basename $(SRC))

clean:
	$(RM) $(UDEV)

uninstall:
	$(RM) -r $(ICONDIR)/batify
	$(RM) $(UDEVDIR)/$(UDEV)
	$(RM) $(BINDIR)/$(shell basename $(SRC))

.PHONY: install clean uninstall
