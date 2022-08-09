#!/bin/bash

export DISPLAY=:0
battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`
state=`acpi -b |sed 's/,/\n/g' |head -n1 |awk '{print $3}'`


if [[ $state == "Discharging" ]]; then
	if [[ $battery_level -le 7 ]]; then
		notify-send --urgency=critical "Battery VERY low" "Level: ${battery_level}%"
		exit
	fi
	if [[ $battery_level -gt 7 && $battery_level -le 20 ]]; then
		notify-send --urgency=normal "Battery low" "Level: ${battery_level}%"
		exit
	fi
fi

