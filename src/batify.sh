#!/usr/bin/env bash
#
# The MIT License (MIT)
#
# Copyright (c) 2015-2016 Thomas "Ventto" Venriès <thomas.venries@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
xtty=$(cat /sys/class/tty/tty0/active)
xuser=$(who | grep "${xtty}"  | head -n1 | cut -d' ' -f1)

if [ -z "${xuser}" ]; then
    echo "No user found from ${xtty}."
    exit 1
fi

xpids=$(pgrep Xorg)
if [ -n "${xpids}" ]; then
    xdisplay=$(ps -o command -p "${xpids}" | grep " vt${xtty:3:${#tty}}" | \
    grep -o ":[0-9]" | head -n 1)
fi

if [ -z "${xdisplay}" ]; then
    #Trying to get the active display from XWayland
    xdisplay=$(pgrep -a Xwayland | cut -d" " -f3)
    if [ -z "${xdisplay}" ]; then
        echo "No X/XWayland process found from ${xtty}."
        exit 1
    fi
fi

for pid in $(ps -u "${xuser}" -o pid --no-headers); do
    env="/proc/${pid}/environ"
    display=$(grep -z "^DISPLAY=" "${env}" | tr -d '\0' | cut -d '=' -f 2)
    if [ -n "${display}" ]; then
        dbus=$(grep -z "DBUS_SESSION_BUS_ADDRESS=" "${env}" | tr -d '\0' | \
            sed 's/DBUS_SESSION_BUS_ADDRESS=//g')
        if [ -n "${dbus}" ]; then
            xauth=$(grep -z "XAUTHORITY=" "${env}" | tr -d '\0' | sed 's/XAUTHORITY=//g')
            break
        fi
    fi
done

if [ -z "${dbus}" ]; then
    echo "No session bus address found."
    exit 1
# XWayland does not need Xauthority 
elif [ -z "${xauth}" ] && [ -n "$xpids" ]; then
    echo "No Xauthority found."
    exit 1
fi

_udev_params=( "$@" )
_bat_name="${_udev_params[0]}"
_bat_capacity="${_udev_params[1]}"
_bat_plug="${_udev_params[2]}"

ICON_DIR="/usr/share/icons/batify"

if [ "${_bat_plug}" != "none" ]; then
	if [ "${_bat_plug}" == "1" ]; then
		ntf_lvl="normal"; icon="bat-plug"
		ntf_msg="Power: plugged in"
	else
		ntf_lvl="normal" ; icon="bat-unplug"
		ntf_msg="Power: unplugged"
	fi
else
	case ${_bat_capacity} in
		[0-9])  ntf_lvl="critical"; icon="bat-critical" ;;
		1[0-5]) ntf_lvl="low";      icon="bat-low"      ;;
		*) exit ;;
	esac
	ntf_msg="[${_bat_name}] - Battery: ${_bat_capacity}%"
fi

[ -f /usr/bin/su ]  && su_path="/usr/bin/su"
[ -f /bin/su ]      && su_path="/bin/su" || su_path=

if [ -z "$su_path" ]; then
    echo "'su' command not found."
    exit 1
fi

icon_path="${ICON_DIR}/${icon}.png"

DBUS_SESSION_BUS_ADDRESS=${dbus} DISPLAY=${xdisplay} XAUTHORITY=${xauth} \
"${su_path}" "${xuser}" -c \
"/usr/bin/notify-send --hint=int:transient:1 -u ${ntf_lvl} -i \"${icon_path}\" \"${ntf_msg}\""
