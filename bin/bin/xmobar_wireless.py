#!/usr/bin/env python3
"""Print wireless state. Interface is designed to mimic options passed to
the Wireless plugin for Xmobar. 

This should work more-or-less identically to the Wireless plugin. Its main
feature is that it automatically detects the current wireless adapter and
shows its information - the standard Wireless plugin must be configured for
one specific adapter at a time. This script, however, is cross-system
compatible so setups using it should require no config file modifications."""

from __future__ import print_function
import subprocess
import re
import sys

# constant for now - it seems to always be in the same location
_IWCONFIG_BINARY = "/sbin/iwconfig"


def run_command(cmd):
    """Run a command and return its stdout as a string. Command must be passed
    as a list of parameters ie ['ls', '-la']"""
    return subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL).stdout.decode('utf-8')


def get_wireless_info():
    """Returns wireless AP and quality (in percent) as a tuple."""
    iwconfig_output = run_command(_IWCONFIG_BINARY)
    for line in iwconfig_output.split("\n"):
        # look for line containing essid, save if its a match
        match = re.match('^[a-zA-Z0-9]+.+ESSID:"(.+)"', line)
        if match:
            essid = match.group(1)
        # if we find the quality line, return
        match = re.match('^\s+Link Quality=(\d+)/(\d+)', line)
        if match:
            quality = 100 * float(match.group(1)) / float(match.group(2))
            return essid, quality
        
    return None, None

def get_formatted_wireless_info(
        template,
        low_threshold=None,
        high_threshold=None,
        low_color=None,
        medium_color=None,
        high_color=None,
        suffix=None,
        bar_width=None):
    essid, quality = get_wireless_info()
    if essid is None:
        print("Wifi not connected", end="")
        sys.exit(0)

    if low_threshold is None:
        low_threshold = 33

    if high_threshold is None:
        high_threshold = 66

    if suffix is None:
        suffix = False

    if bar_width is None:
        bar_width = 10

    # make 'short' name by trimming words to 3 chars
    essid_short = ' '.join([word[:3] for word in essid.split()])

    if quality < float(low_threshold):
        color = low_color
    elif quality < float(high_threshold):
        color = medium_color
    else:
        color = high_color

    if quality > 100:
        quality = 100
    if quality < 0:
        quality = 0

    scale_val = 100 / bar_width
    qualitybar = "#" * round(quality / scale_val) + ":" * round(
        (100 - quality) / scale_val
    )

    # scale 0-100 (101 values) to 0-8 (9 values)
    template = template.replace("%%", "{:02d}".format(int(9*quality/101.0)))

    quality = "{:.0f}".format(quality)
    if color is not None:
        quality = "<fc={}>{}</fc>".format(color, quality)
    if suffix:
        quality += "%"

    template = template.replace("<essid>", essid)
    template = template.replace("<essid_short>", essid_short)
    template = template.replace("<quality>", quality)
    template = template.replace("<qualitybar>", qualitybar)
    return template

if __name__ == "__main__":
    import argparse

    # Initialize arg parser. Note since we override -h, add_help must be false
    p = argparse.ArgumentParser(
        description="Print wireless status for xmobar", add_help=False
    )
    p.add_argument(
        "-t",
        "--template",
        default="<essid>:<quality>",
        type=str,
        metavar="TEMPLATE",
        help=(
            "Output template. Definition is a subset of the standard xmobarr Wireless "
            "plugin. Allowed values: essid, quality, qualitybar. Custom values: "
            "essid_short. "
        ),
    )
    p.add_argument(
        "-H",
        "--High",
        default=66,
        type=int,
        metavar="NUMBER",
        help=(
            "The high threshold. Values higher than number will be displayed with the "
            "color specified by -h"
        ),
    )
    p.add_argument(
        "-L",
        "--Low",
        default=33,
        type=int,
        metavar="NUMBER",
        help=(
            "The low threshold. Values lower than number will be displayed with the "
            "color specified by -l"
        ),
    )
    p.add_argument(
        "-h",
        "--high",
        metavar="COLOR",
        help="Color for showing values over the high threshold.",
    )
    p.add_argument(
        "-n",
        "--normal",
        metavar="COLOR",
        help=(
            "Color for showing values greater than the low threshold but lower than "
            "the high one."
        ),
    )
    p.add_argument(
        "-l",
        "--low",
        metavar="COLOR",
        help="Color for showing values below the low threshold.",
    )
    p.add_argument(
        "-S",
        "--suffix",
        default=False,
        action="store_true",
        help="When true show optional suffixes such as % or units",
    )
    p.add_argument(
        "-W",
        "--bwidth",
        default=10,
        type=int,
        metavar="NUMBER",
        help="Total number of characters used to draw bars.",
    )
    # not implemented: -p --ppad
    # not implemented: -d --ddigits
    # not implemented: -m --minwidth
    # not implemented: -M --maxwidth
    # not implemented: -e --maxwidthellipsis
    # not implemented: -w --width
    # not implemented: -T --maxtwidth
    # not implemented: -E --maxtwidthellipsis
    # not implemented: -c --padchars
    # not implemented: -a --align
    # not implemented: -b --bback
    # not implemented: -f --bfore
    # not implemented: -W --bwidth
    # not implemented: -x --nastring
    p.add_argument(
        "--quality-icon-pattern",
        help=(
            "Dynamic string for connection quality in "
            "qualityipat. Not currently implemented."
        ),
    )
    # Add explicit --help arg, since -h arg is disabled.
    # TODO: figure out why this does not work
    # p.add_argument('--help', action='help', help='show this help message and exit')
    args = p.parse_args()

    output = get_formatted_wireless_info(
        args.template,
        low_threshold=args.Low,
        high_threshold=args.High,
        low_color=args.low,
        medium_color=args.normal,
        high_color=args.high,
        suffix=args.suffix,
        bar_width=args.bwidth)

    print(output, end="")

