Batify
====
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/Ventto/batify/blob/master/LICENSE)
[![Version](https://img.shields.io/badge/version-0.7-orange.svg?style=flat)](https://github.com/Ventto/batify/)
[![Language (Bash)](https://img.shields.io/badge/powered_by-Bash-brightgreen.svg)](https://www.gnu.org/software/bash/)

*Batify is an easy way to set battery level warnings using [udev rules](https://wiki.archlinux.org/index.php/Udev) and [libnotify](https://wiki.archlinux.org/index.php/Desktop_notifications).*

# Install

## Requirements

In order to use libnotify, you have to install a [notification server](https://wiki.archlinux.org/index.php/Desktop_notifications).

## Package

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

# How does it work ?

Basically:

* The batify's udev rule is hooked "change/discharging battery" event
* When it is triggered, the latter runs a script and the script runs *notify-send*.

# Custom battery warnings

* Edit `/usr/local/bin/batify.sh`:

```bash
case ${_bat_capacity} in
	[0-9])  ntf_lvl=critical; icon="critical" ;;
	1[0-5]) ntf_lvl=low;      icon="low"      ;;

	# Custom warnings (battery half level)
	5[0-3]) ntf_lvl=normal; icon="half" ;;
	50) ... ;;

	*) exit ;;
esac
```

# Custom icons

There are basic icons with batify but you can obviously use yours.

 * Edit `/usr/local/bin/batify.sh`:

 ```bash
declare -A ntf_icons

ntf_icons['critical']="/usr/share/icons/batify/battery_critical.png"
...
ntf_icons['my_icon_name']="<path>/my_icon.png"
```



