#!/bin/bash
#
# Copyright (C) 2015 Ignas Anikevicius
#
# This script does not come with any guaranties to work and might eat your cat
# if something goes wrong.

LOGITECH_DEVICE=${1}

if [ -z ${LOGITECH_DEVICE} ]; then
    LOGITECH_DEVICE="Logitech Rechargeable Touchpad T650"
fi

# Set middle click to three finger tap
xinput set-prop "${LOGITECH_DEVICE}" "Synaptics Click Action" 1 3 2
# corners: rt rb lt lb; fingers: left middle right
xinput set-prop "${LOGITECH_DEVICE}" "Synaptics Tap Action" 0 0 0 0 1 3 2

# Enable two finger scrolling for both axes
xinput set-prop "${LOGITECH_DEVICE}" "Synaptics Two-Finger Scrolling" 1 1

# Device Enabled (136):   1
# Coordinate Transformation Matrix (138): 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000
# Device Accel Profile (268):     1
# Device Accel Constant Deceleration (269):       2.500000
# Device Accel Adaptive Deceleration (270):       1.000000
# Device Accel Velocity Scaling (271):    12.500000
# Synaptics Edges (292):  113, 2719, 127, 2237
# Synaptics Finger (293): 4, 5, 0
# Synaptics Tap Time (294):       180
# Synaptics Tap Move (295):       162
# Synaptics Tap Durations (296):  180, 180, 100
# Synaptics ClickPad (297):       1
# Synaptics Middle Button Timeout (298):  0
# Synaptics Two-Finger Pressure (299):    56
# Synaptics Two-Finger Width (300):       7
# Synaptics Scrolling Distance (301):     73, 73
# Synaptics Edge Scrolling (302): 0, 0, 0
# Synaptics Two-Finger Scrolling (303):   1, 0
# Synaptics Move Speed (304):     1.000000, 1.750000, 0.054230, 0.000000
# Synaptics Off (305):    0
# Synaptics Locked Drags (306):   0
# Synaptics Locked Drags Timeout (307):   5000
# Synaptics Circular Scrolling (310):     0
# Synaptics Circular Scrolling Distance (311):    0.100000
# Synaptics Circular Scrolling Trigger (312):     0
# Synaptics Circular Pad (313):   0
# Synaptics Palm Detection (314): 0
# Synaptics Palm Dimensions (315):        10, 39
# Synaptics Coasting Speed (316): 20.000000, 50.000000
# Synaptics Pressure Motion (317):        5, 31
# Synaptics Pressure Motion Factor (318): 1.000000, 1.000000
# Synaptics Grab Event Device (319):      0
# Synaptics Gestures (320):       1
# Synaptics Capabilities (321):   1, 0, 0, 1, 1, 1, 0
# Synaptics Pad Resolution (322): 23, 23
# Synaptics Area (323):   0, 0, 0, 0
# Synaptics Soft Button Areas (828):      1416, 0, 1938, 0, 0, 0, 0, 0
# Synaptics Noise Cancellation (324):     18, 18
# Device Product ID (257):        1133, 16641
# Device Node (258):      "/dev/input/event17"
