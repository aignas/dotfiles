#!/bin/bash
#
# Copyright (C) 2015 Ignas Anikevicius
#
# This script does not come with any guaranties to work and might eat your cat
# if something goes wrong.

LOGITECH_DEVICE=${1}

if [ -z ${LOGITECH_DEVICE} ]; then
    LOGITECH_DEVICE="Logitech M570"
fi

# Set the button configuration correctly
# Software ids:                            1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
xinput set-button-map "${LOGITECH_DEVICE}" 1 0 3 4 5 6 7 2 0  0  0  6  7  4  5

xinput set-prop "${LOGITECH_DEVICE}" "libinput Button Scrolling Button" 9
xinput set-prop "${LOGITECH_DEVICE}" "libinput Scroll Method Enabled" 0 0 1

# Set the wheel emulation and adjust the inertia a bit
#xinput set-prop "${LOGITECH_DEVICE}" "Evdev Wheel Emulation" 1
#xinput set-prop "${LOGITECH_DEVICE}" "Evdev Wheel Emulation Axes" 12 13 14 15
#xinput set-prop "${LOGITECH_DEVICE}" "Evdev Wheel Emulation Inertia" 15

# Adjust the deceleration settings
#xinput set-prop "${LOGITECH_DEVICE}" "Device Accel Constant Deceleration" 1.5
# Device 'Logitech M570':
# 	Device Enabled (136):	1
# 	Coordinate Transformation Matrix (138):	1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000
# 	libinput Accel Speed (271):	0.000000
# 	libinput Natural Scrolling Enabled (272):	0
# 	libinput Send Events Modes Available (256):	1, 0
# 	libinput Send Events Mode Enabled (257):	0, 0
# 	libinput Left Handed Enabled (273):	0
# 	libinput Scroll Methods Available (274):	0, 0, 1
# 	libinput Scroll Method Enabled (275):	0, 0, 0
# 	libinput Button Scrolling Button (278):	0
# 	Device Node (258):	"/dev/input/event5"
# 	Device Product ID (259):	1133, 4136
