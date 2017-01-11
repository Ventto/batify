Batify
====
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/Ventto/batify/blob/master/LICENSE)
[![Version](https://img.shields.io/badge/version-0.9-orange.svg?style=flat)](https://github.com/Ventto/batify/)
[![Language (Bash)](https://img.shields.io/badge/powered_by-Bash-brightgreen.svg)](https://www.gnu.org/software/bash/)

*Batify is a Bash script to set easily plug and battery level notifications using [udev rules](https://wiki.archlinux.org/index.php/Udev) and [libnotify](https://wiki.archlinux.org/index.php/Desktop_notifications) for single and multi-xusers.*

# Installation

## Requirements

In order to use libnotify, you need to install a [notification server](https://wiki.archlinux.org/index.php/Desktop_notifications).

## Package (AUR)

```
$ yaourt -S batify
```

## Manually

```
$ git clone https://github.com/Ventto/batify.git
$ cd batify
$ make
$ sudo make install
```

**After installing *batify*, do not forget to reload udev rules:**

```
$ udevadm control --reload-rules
```

# Notifications

*"A batifyrc configuration file is comming soon"*

Current notifications:

| notification | level |
|---|---|
| Battery level is between 10% and 15% | normal |
| Battery level is less than 9% | critical |
| AC adapter plugged-in | normal |
| AC adapter unplugged | normal |

Batify's files:

* `/etc/udev/rules.d/99-batify.rules`
* `/usr/local/bin/batify.sh`
* `/usr/share/icons/batify/*.png`


## Custom battery warnings

* Edit `batify.sh`:

```bash
case ${_bat_capacity} in
	[0-9])  ntf_lvl=critical; icon="bat-critical" ;;
	1[0-5]) ntf_lvl=low;      icon="bat-low"      ;;

	# Custom warnings (battery half level)
	5[0-3]) ntf_lvl=normal; icon="bat-half" ;;
	50) ... ;;

	*) exit ;;
esac
```

## Custom plug in/unplug notifications

* Edit `batify.sh`:

```bash
if [ "${_bat_plug}" == "1" ]; then
	ntf_lvl="normal"; icon="bat-plug"
	ntf_msg="Power: plugged in"
else
	ntf_lvl="normal" ; icon="bat-unplug"
	ntf_msg="Power: unplugged"
fi
```

## Custom icons

* Edit `batify.sh`:

```bash
ICON_DIR="/usr/share/icons/batify"
#[...]
icon_path="${ICON_DIR}/${icon}.png"
```

