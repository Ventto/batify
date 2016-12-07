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
export XAUTHORITY="/home/${USER}/.Xauthority"
export DISPLAY="0:0"

for pid in $(pgrep -u $USER dbus-daemon); do
	env="/proc/${pid}/environ"
	dbus=$(grep -z DBUS_SESSION_BUS_ADDRESS $env | cut -d ':' -f 2 | tr -d '\0')
	if [ -n "${dbus##^unix:*}" ]; then
		break
	fi
done

if [ -z "$dbus" ]; then
	echo "No dbus-daemon process found."
	exit 1
fi

export DBUS_SESSION_BUS_ADDRESS="unix:${dbus}"

_udev_params=( "$@" )
_bat_name="${_udev_params[0]}"
_bat_capacity="${_udev_params[1]}"
_bat_plug="${_udev_params[2]}"

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
		[0-9])  ntf_lvl="critical"; icon="critical" ;;
		1[0-5]) ntf_lvl="low";      icon="low"      ;;
		*) exit ;;
	esac
	ntf_msg="[${_bat_name}] - Battery: ${_bat_capacity}%"
fi

icon_dir="/usr/share/icons/batify"
icon_path="${icon_dir}/${icon}.png"

/usr/bin/notify-send -u ${ntf_lvl} -i "${icon_path}" "${ntf_msg}"
