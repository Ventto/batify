SHELL := /bin/bash

UDEVDIR = $(DESTDIR)/etc/udev/rules.d
BINDIR  = $(DESTDIR)/usr/local/bin
ICONDIR = $(DESTDIR)/usr/share/icons

BAT_UDEV = 99-$(shell basename $(basename $(SRC)))-battery.rules
PWR_UDEV = 98-$(shell basename $(basename $(SRC)))-power.rules

SRC  = src/batify.sh

all:$(BAT_UDEV) $(PWR_UDEV)

$(BAT_UDEV):$(SRC)
	@echo -e 'ACTION=="change", KERNEL=="BAT0", \\' >  $(BAT_UDEV)
	@echo -e 'SUBSYSTEM=="power_supply", \\'        >> $(BAT_UDEV)
	@echo -e 'ATTR{status}=="Discharging", \\'      >> $(BAT_UDEV)
	@echo -n 'RUN+="$(shell whereis su | cut -d ' ' -f 2) $(USER) -c ' >> $(BAT_UDEV)
	@echo -e ''\''/usr/local/bin/batify.sh %k $$attr{capacity} none'\''"' >> $(BAT_UDEV)

$(PWR_UDEV):$(SRC)
	@echo -e 'SUBSYSTEM=="power_supply", ACTION=="change", \\' >> $(PWR_UDEV)
	@echo -e 'ENV{POWER_SUPPLY_ONLINE}=="0", ENV{POWER}="off", \\' >> $(PWR_UDEV)
	@echo -e 'OPTIONS+="last_rule", \\' >> $(PWR_UDEV)
	@echo -n 'RUN+="$(shell whereis su | cut -d ' ' -f 2) $(USER) -c ' >> $(PWR_UDEV)
	@echo -e ''\''/usr/local/bin/batify.sh none none 0'\''"' >> $(PWR_UDEV)
	@echo >> $(PWR_UDEV)
	@echo -e 'SUBSYSTEM=="power_supply", ACTION=="change", \\' >> $(PWR_UDEV)
	@echo -e 'ENV{POWER_SUPPLY_ONLINE}=="1", ENV{POWER}="on", \\' >> $(PWR_UDEV)
	@echo -e 'OPTIONS+="last_rule", \\' >> $(PWR_UDEV)
	@echo -n 'RUN+="$(shell whereis su | cut -d ' ' -f 2) $(USER) -c ' >> $(PWR_UDEV)
	@echo -e ''\''/usr/local/bin/batify.sh none none 1'\''"' >> $(PWR_UDEV)

install: all
	mkdir -p $(UDEVDIR)
	mkdir -p $(ICONDIR)
	mkdir -p $(BINDIR)
	cp $(BAT_UDEV) $(UDEVDIR)
	cp $(PWR_UDEV) $(UDEVDIR)
	cp -r icons $(ICONDIR)/batify
	cp $(SRC) $(BINDIR)/$(shell basename $(SRC))

clean:
	$(RM) $(BAT_UDEV)
	$(RM) $(PWR_UDEV)

uninstall:
	$(RM) -r $(ICONDIR)/batify
	$(RM) $(UDEVDIR)/$(BAT_UDEV)
	$(RM) $(UDEVDIR)/$(PWR_UDEV)
	$(RM) $(BINDIR)/$(shell basename $(SRC))

.PHONY: install clean uninstall
