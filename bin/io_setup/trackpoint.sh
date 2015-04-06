# !/bin/bash

trackpoint() {
    # Set the sensitivity
}

trackp_sysfs() {
    echo "Setting Trackpoint parameters"

    # Set the properties
    echo $1 > ${DIR}/press_to_select; shift
    echo $1 > ${DIR}/inertia; shift
    echo $1 > ${DIR}/sensitivity; shift
    echo $1 > ${DIR}/speed; shift

    echo "Done"

    return 0
}

#main $@
# 
# Device 'TPPS/2 IBM TrackPoint':
# 	Device Enabled (132):	1
# 	Coordinate Transformation Matrix (134):	1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000
# 	Device Accel Profile (254):	0
# 	Device Accel Constant Deceleration (256):	1.000000
# 	Device Accel Adaptive Deceleration (257):	1.000000
# 	Device Accel Velocity Scaling (258):	10.000000
# 	Device Product ID (250):	2, 10
# 	Device Node (251):	"/dev/input/event11"
# 	Evdev Axis Inversion (292):	0, 0
# 	Evdev Axes Swap (294):	0
# 	Axis Labels (295):	"Rel X" (142), "Rel Y" (143)
# 	Button Labels (296):	"Button Left" (135), "Button Middle" (136), "Button Right" (137), "Button Wheel Up" (138), "Button Wheel Down" (139), "Button Horiz Wheel Left" (140), "Button Horiz Wheel Right" (141)
# 	Evdev Middle Button Emulation (297):	0
# 	Evdev Middle Button Timeout (298):	50
# 	Evdev Third Button Emulation (299):	0
# 	Evdev Third Button Emulation Timeout (300):	1000
# 	Evdev Third Button Emulation Button (301):	3
# 	Evdev Third Button Emulation Threshold (302):	20
# 	Evdev Wheel Emulation (303):	1
# 	Evdev Wheel Emulation Axes (304):	6, 7, 4, 5
# 	Evdev Wheel Emulation Inertia (305):	10
# 	Evdev Wheel Emulation Timeout (306):	200
# 	Evdev Wheel Emulation Button (307):	2
# 	Evdev Drag Lock Buttons (308):	0
# Device 'Virtual core XTEST pointer':
# 	Device Enabled (132):	1
# 	Coordinate Transformation Matrix (134):	1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000
# 	XTEST Device (248):	1
