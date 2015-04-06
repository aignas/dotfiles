#!/usr/bin/python3

import sys
from subprocess import Popen
from os.path import dirname, isfile, join
from argparse import ArgumentParser
from os import listdir


def get_prop(fname):
    r = None
    with open(fname, "r") as prop_file:
        r = prop_file.read().strip()

    return int(r)


def set_prop(fname, message):
    with open(fname, "w") as prop_file:
        prop_file.write(message)


def get_tracp_sysfs(directory, props):
    print("Getting Trackpoint parameters")

    dd = dirname(directory)

    # Check if all files are present
    files_present = True
    for i in props:
        files_present = files_present and isfile(join(dd, i))
        if not files_present:
            break

    if files_present:
        directory = dd

    defaults = {i: get_prop(join(directory, i)) for i in props}

    # Set the default directory:
    defaults['directory'] = directory

    return defaults


def set_tracp_sysfs(directory, **kwargs):
    print("Setting Trackpoint parameters")

    # Add a slash if it is missing.
    if directory != dirname(directory):
        directory = directory + '/'

    # Execute all the 
    for key, value in kwargs.items():
        print("Setting " + key + " to " + value)
        value = directory + value
        set_prop(key, value)

    print("Done")


def main():
    parser = ArgumentParser(
            description="""
        Small script to set the trackpoint parameters and optionally remember.
        """)
    parser.add_argument("-p", "--press-to-select", type=int,
            help="""
            Set the press to select state. 1 - enabled, 0 - disabled.
            """)
    parser.add_argument("-i", "--inertia", type=int,
            help="""
            Set the inertia of the trackpoint.
            """)
    parser.add_argument("-S", "--sensitivity", type=int,
            help="""
            Set the sensitivity of the trackpoint.
            """)
    parser.add_argument("-s", "--speed", type=int,
            help="""
            Set the speed of the trackpoint.
            """)
    parser.add_argument("-g", "--get", 
            help="""
            Print the parameters.
            """)

    # Parse arguments
    args = vars(parser.parse_args())
    opts = {}

    # defaults
    defaults = { 'directory': '/sys/devices/platform/i8042/serio1/serio2' }
    defaults = dict( get_tracp_sysfs(defaults['directory'], args.keys()), **defaults )

    # Get the None values
    for key, value in args.items():
        if value != None:
            opts[key] = value
        else:
            opts[key] = defaults[key]

    # Execute the switcher
    set_tracp_sysfs(directory, **opts)

    return 0


if __name__ == "__main__":
	main()
