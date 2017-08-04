Batify
======

*Batify is an udevrule-file triggering plug and critical battery level notifications
(using libnotify and [xpub](https://github.com/Ventto/xpub))*

## Perks

* [x] **Minimal**: only one udevrule-file (using *libnotify*).
* [x] **Everywhere**: displays notifications on any current graphical session.
* [x] **Support**: for XWayland as well.

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

**Warning: After installing *batify*, do not forget to reload udev rules:**

```
$ udevadm control --reload-rules
```

# Notifications

| Description | Level |
|---|---|
| Battery level is between 10% and 15% | normal |
| Battery level is less or equal than 9% | critical |
| AC adapter plugged-in | low |
| AC adapter unplugged | low |

# Troubleshooting

## No battery level warnings displayed

* You might need to replace `BAT0` with your battery identifier:

```bash
ACTION=="change", KERNEL=="BAT0", \
```
