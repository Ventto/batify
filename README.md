Batify
====
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/Ventto/batify/blob/master/LICENSE)
[![Status](https://img.shields.io/badge/status-experimental-orange.svg?style=flat)](https://github.com/Ventto/batify/)
[![Language (Bash)](https://img.shields.io/badge/powered_by-Bash-brightgreen.svg)](https://www.gnu.org/software/bash/)

*Batify is an easy way to set battery level warnings using [udev rules](https://wiki.archlinux.org/index.php/Udev) and [libnotify](https://wiki.archlinux.org/index.php/Desktop_notifications).*

## Install

```
$ git clone https://github.com/Ventto/batify.git
$ cd batify
$ make
$ sudo make install
```

## How does it work ?

Basically:

* The batify's udev rule is hooked "change/discharging battery" event
* When it is triggered, the latter calls a script and the script calls *notify-send*.

## Custom battery warnings

* Edit `/usr/local/bin/batify.sh`:

```
case ${_bat_capacity} in
	[0-9])    ntf_lvl=critical; icon="critical" ;;
	[10-15])  ntf_lvl=low;      icon="low"      ;;
	[50-60])  ntf_lvl=normal;   icon="half"     ;;

	[n1-n2]) ntf_lvl=[critical | low | normal];   icon="<icon_name>" ;;
	n) ...

	*) exit ;;
esac
```

## Custom icons

There are basic icons with batify but you can obviously use yours.

 * Edit `/usr/local/bin/batify.sh`:

 ```
declare -A ntf_icons
ntf_icons['critical']="/usr/share/icons/batify/battery_critical.png"
...
ntf_icons['my_icon_name']="<path>/my_icon.png"
```



