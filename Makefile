SRC  = src/batify.sh
UDEV = 99-$(shell basename $(basename $(SRC))).rules

all:$(UDEV)

$(UDEV):
	@echo -e 'ACTION=="change", KERNEL=="BAT0", \\' >  $(UDEV)
	@echo -e 'SUBSYSTEM=="power_supply", \\'        >> $(UDEV)
	@echo -e 'ATTR{status}=="Discharging", \\'      >> $(UDEV)
	@echo -n 'RUN+="/usr/bin/su $(USER) -c '        >> $(UDEV)
	@echo -e ''\''/usr/local/bin/batify.sh %k $$attr{capacity}'\''"' >> $(UDEV)

install: $(UDEV)
	cp $(UDEV) /etc/udev/rules.d
	cp -r icons /usr/share/icons/batify
	cp $(SRC) /usr/local/bin/$(shell basename $(SRC))
	udevadm control --reload-rules

clean:
	$(RM) $(UDEV)

distclean: clean
	$(RM) -r /usr/share/icons/batify
	$(RM) /etc/udev/rules.d/$(UDEV)
	$(RM) /usr/local/bin/$(shell basename $(SRC))

.PHONY: install clean distclean
