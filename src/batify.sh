#!/usr/bin/env bash

export XAUTHORITY="/home/${USER}/.Xauthority"
export DISPLAY="0:0"

platform=$(lsb_release -i | awk -F"\t" '{print $2}')

if [ "${platform}" == "Arch" ]; then
	dbus="path=/run/user/${UID}/bus"
elif [ "${platform}" == "Ubuntu" ]; then
	pid=$(pgrep -u $USER nautilus)
	dbus=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/${pid}/environ | cut -d ':' -f 2)
fi

export DBUS_SESSION_BUS_ADDRESS="unix:${dbus}"

_udev_params=( "$@" )
_bat_name="${_udev_params[0]}"
_bat_capacity="${_udev_params[1]}"

case ${_bat_capacity} in
	[0-9])  ntf_lvl=critical; icon="critical" ;;
	1[0-5]) ntf_lvl=low;      icon="low"      ;;
	*) exit ;;
esac

ntf_msg="[${_bat_name}] - Battery: ${_bat_capacity}%"

declare -A ntf_icons

ntf_icons['critical']="/usr/share/icons/batify/battery_critical.png"
ntf_icons['low']="/usr/share/icons/batify/battery_low.png"
ntf_icons['normal']="/usr/share/icons/batify/battery_normal.png"
ntf_icons['half']="/usr/share/icons/batify/battery_half.png"

/usr/bin/notify-send -u ${ntf_lvl} -i "${ntf_icons[$icon]}" "${ntf_msg}"
