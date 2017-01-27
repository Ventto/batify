SHELL := /bin/bash

UDEVDIR = $(DESTDIR)/etc/udev/rules.d
BINDIR  = $(DESTDIR)/usr/local/bin
ICONDIR = $(DESTDIR)/usr/share/icons/batify

SRC     = src/batify.sh
UDEV    = 99-batify.rules

all:$(UDEV)

$(UDEV):
	@echo -e 'ACTION=="change", KERNEL=="BAT0", \\'                       >  $@
	@echo -e 'SUBSYSTEM=="power_supply", \\'                              >> $@
	@echo -e 'ATTR{status}=="Discharging", \\'                            >> $@
	@echo -e 'RUN+="/usr/local/bin/batify.sh %k $$attr{capacity} none"\n' >> $@
	@echo -e 'SUBSYSTEM=="power_supply", ACTION=="change", \\'            >> $@
	@echo -e 'ENV{POWER_SUPPLY_ONLINE}=="0", ENV{POWER}="off", \\'        >> $@
	@echo -e 'OPTIONS+="last_rule", \\'                                   >> $@
	@echo -e 'RUN+="/usr/local/bin/batify.sh none none 0"\n'              >> $@
	@echo -e 'SUBSYSTEM=="power_supply", ACTION=="change", \\'            >> $@
	@echo -e 'ENV{POWER_SUPPLY_ONLINE}=="1", ENV{POWER}="on", \\'         >> $@
	@echo -e 'OPTIONS+="last_rule", \\'                                   >> $@
	@echo -e 'RUN+="/usr/local/bin/batify.sh none none 1"'                >> $@

install: all
	mkdir -p $(UDEVDIR)
	mkdir -p $(BINDIR)
	mkdir -p $(ICONDIR)
	cp icons/*.png $(ICONDIR)
	cp $(UDEV) $(UDEVDIR)/$(UDEV)
	cp $(SRC) $(BINDIR)/$(shell basename $(SRC))

uninstall:
	$(RM) -r $(ICONDIR)
	$(RM) $(UDEVDIR)/$(UDEV)
	$(RM) $(BINDIR)/$(shell basename $(SRC))

.PHONY: all install uninstall
