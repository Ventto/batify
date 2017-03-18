Batify
====
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/Ventto/batify/blob/master/LICENSE)

*Batify is an udevrule to display plug and critical battery level [notifications](https://wiki.archlinux.org/index.php/Desktop_notifications) (using libnotify)*

## Perks

* [x] **No requirement**: only one udevrule file.
* [x] **Multi X-sessions support**: using [xpub](https://github.com/Ventto/xpub.git).

# Installation

## Requirements

Using libnotify, you might need to install a [notification server](https://wiki.archlinux.org/index.php/Desktop_notifications).

## Package (AUR)

```
$ yaourt -S batify
```

## Manually

```
$ git clone --recursive https://github.com/Ventto/batify.git
$ cd batify
$ sudo make install
```

**After installing *batify*, do not forget to reload udev rules:**

```
$ udevadm control --reload-rules
```

# Notifications

| Description | Level |
|---|---|
| Battery level is between 10% and 15% | normal |
| Battery level is less than 9% | critical |
| AC adapter plugged-in | low |
| AC adapter unplugged | low |

# Troubleshooting

## No battery level warnings displayed

* You might need to replace `BAT0` with your battery name :

```bash
ACTION=="change", KERNEL=="BAT0", \
```
