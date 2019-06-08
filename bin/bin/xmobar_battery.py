#!/usr/bin/env python3
"""Print battery info. Interface is designed to mimic options passed to
the Battery plugin for Xmobar. 

This should work more-or-less identically to the Battery plugin with a few features:

    - shows correct status for dell batteries when configured to a custom charge range
      with BIOS PrimaryBatteryCfg
    - does not require "--" parameter to be passed on cmdline to separate default
      arguments from battery-specific ones
    - a lot more options
"""

from __future__ import print_function
import subprocess
import re
import sys

# threshold under which battery is considered "charged" in milliamps
_CHARGE_MODE_THRESHOLD_MA = 5
# constant for now - it seems to always be in the same location
_IWCONFIG_BINARY = "/sbin/iwconfig"


class IWConfigNotFoundError:
    pass


def run_command(cmd):
    """Run a command and return its stdout as a string. Command must be passed
    as a list of parameters ie ['ls', '-la']"""
    return subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL).stdout.decode('utf-8')

def read_file(filename):
    with open(filename, 'r') as f:
        return f.read()


class Battery():
    def __init__(self, identifier="BAT0"):
        self._prefix = "/sys/class/power_supply/" + identifier + "/"
        self.identifier = identifier

    @property
    def manufacturer(self):
        return read_file(self._prefix + "manufacturer").strip()

    @property
    def model(self):
        return read_file(self._prefix + "model_name").strip()

    @property
    def voltage(self):
        val_ua = int(read_file(self._prefix + "voltage_now"))
        return val_ua / 1000000.0

    @property
    def current_draw_amps(self):
        val_ua = int(read_file(self._prefix + "current_now"))
        return val_ua / 1000000.0
    
    @property
    def watts(self):
        return self.voltage * self.current_draw_amps

    @property
    def capacity_now_amphours(self):
        val_uah = int(read_file(self._prefix +"charge_now"))
        return val_uah / 1000000.0

    @property
    def capacity_full_amphours(self):
        val_uah = int(read_file(self._prefix +"charge_full"))
        return val_uah / 1000000.0

    @property
    def capacity_full_design_amphours(self):
        val_uah = int(read_file(self._prefix +"charge_full_design"))
        return val_uah / 1000000.0

    @property
    def charge_percent(self):
        val = 100.0 * self.capacity_now_amphours / self.capacity_full_amphours
        if val > 100:
            val = 100
        elif val < 0:
            val = 0

        return val 

    @property
    def health_percent(self):
        val = 100.0 * self.capacity_full_amphours / self.capacity_full_design_amphours
        if val > 100:
            val = 100
        elif val < 0:
            val = 0

        return val

    @property
    def health_percent_readable(self):
        return "{:.0f}".format(self.health_percent)

    @property
    def status(self):
        """Determine the _real_ state of the battery (Charging/Discharging/AC Idle)
        using the current draw of the battery, output of tlp-stat, and /sys status."""
        sys_class_status = read_file(self._prefix + "status").strip()

        # tlp_output = run_command('tlp-stat -s')
        # tlp_status = None
        # for line in tlp_output:
        #     re.match("^Mode\W+=\W+(?P<mode>.+)$", line)
        #     if match:
        #         tlp_status = match.group(1)
        # if tlp_status is None:
        #     raise RuntimeError("Failed to parse 'tlp-stat -s' output")

        if (self.current_draw_amps * 1000.0) > _CHARGE_MODE_THRESHOLD_MA:
            # if current is flowing battery is either charging or discharging
            if sys_class_status == "Charging":
                return "Charging"
            if sys_class_status == "Unknown":
                return "Discharging"
            if sys_class_status == "Discharging":
                return "Discharging"
        else:
            # no current through battery so must be idling on AC
            return "AC Idle"

    @property
    def time_left_readable(self):
        val = self.time_left_readable_include_seconds
        if val is "":
            return ""
        else:
            return val[:-3]

    @property
    def time_left_readable_include_seconds(self):
        if self.identifier.startswith('BAT'):
            # pull number off the end of identifier and use when search acpi output
            desired_battery_id = self.identifier[3:]

        acpi_battery_info = run_command(['acpi', '-b'])

        # regex matches both these strings, named group 'time_left' is optional:
        # Battery 0: Discharging, 96%, 05:25:42 remaining
        # Battery 0: Full, 100%
        regex_str = "^Battery (?P<id>\d+): (?P<status>\w+), (?P<charge_percent>\d+)%(?:, (?P<time_left>[\d:]+) (remaining|until charged))*$"
        for line in acpi_battery_info.split('\n'):
            match = re.match(regex_str, line)
            if match:
                battery_id, status, charge_percent, time_left, suffix = match.groups()
                time_left = "" if time_left is None else time_left
                if battery_id == desired_battery_id:
                    # trim off seconds if show_seconds is false
                    return time_left
        raise RuntimeError("Failed to find battery info in 'acpi -b' output")

    @property
    def time_left_seconds(self):
        val = self.time_left_readable_include_seconds
        if val is "":
            return ""
        else:
            hours, minutes, seconds = [int(n) for n in val.split(":")]
            return (hours * 3600) + (minutes * 60) + seconds


if __name__ == "__main__":
    import argparse

    # Initialize arg parser. Note since we override -h, add_help must be false
    p = argparse.ArgumentParser(
        description="Print battery status for xmobar", add_help=False
    )
    p.add_argument(
        "battery_id",
        type=str,
        help="Battery identifier (BAT0 on most systems; check /sys/class/power_supply/)",
    )
    p.add_argument(
        "--show-debug-info",
        default=False,
        action="store_true",
        help="If true output all battery information to stdout.",
    )
    p.add_argument(
        "-t",
        "--template",
        #default="Batt: <watts>, <left>% / <timeleft>"
        default="Batt: <watts>W, <left>% / <timeleft> (<acstatus>) <leftbar>",
        type=str,
        metavar="TEMPLATE",
        help=(
            "Output template. Definition is a subset of the standard xmobarr Battery "
            "plugin. Allowed values: left, leftbar, leftipat, timeleft, watts, "
            "acstatus. Also allowed custom values: health."
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
        "-O",
        "--on-ac-status",
        default="On",
        type=str,
        metavar="TEMPLATE",
        help='string for AC "on" status (default: "On")',
    )
    p.add_argument(
        "-i",
        "--idle-ac-status",
        default="Idle",
        type=str,
        metavar="TEMPLATE",
        help='string for AC "idle" status (default: "On")'
    )
    p.add_argument(
        "-o",
        "--off-ac-status",
        default="Off",
        type=str,
        metavar="TEMPLATE",
        help='string for AC "off" status (default: "Off")'
    )
    p.add_argument(
        "--on-icon-pattern",
        default="",
        type=str,
        metavar="STRING",
        help='dynamic string for current battery charge when AC is "on" in leftipat'
    )
    p.add_argument(
        "--off-icon-pattern",
        default="",
        type=str,
        metavar="STRING",
        help='dynamic string for current battery charge when AC is "off" in leftipat'
    )
    p.add_argument(
        "--idle-icon-pattern",
        default="",
        type=str,
        metavar="STRING",
        help='dynamic string for current battery charge when AC is "idle" in leftipat'
    )
    p.add_argument(
        "-W",
        "--bwidth",
        default=10,
        type=int,
        metavar="NUMBER",
        help="Total number of characters used to draw bars.",
    )
    # not implemented: -S --suffix
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
    # not implemented: -x --nastring

    # Add explicit --help arg, since -h arg is disabled.
    # TODO: figure out why this does not work
    # p.add_argument('--help', action='help', help='show this help message and exit')
    
    args = p.parse_args(args=[x for x in sys.argv[1:] if x != "--"])

    try:
        b = Battery("BAT0")
        charge = b.charge_percent
    except Exception as e:
        print("No Battery")
        import traceback
        traceback.print_exc()
        sys.exit(1)

    # print all info for debugging
    if args.show_debug_info:
        all_vals = [attr for attr in dir(b) 
                    if not attr.startswith('__')]
        for val in all_vals:
            try:
                print("  {}: {}".format(val, getattr(b, val)))
            except Exception as e:
                print("Error reading {}: {}".format(val, str(e)))
                import traceback
                traceback.print_exc()
                sys.exit(1)

    if charge < float(args.Low):
        color = args.low
    elif charge < float(args.High):
        color = args.normal
    else:
        color = args.high

    scale_val = 100 / args.bwidth
    leftbar = "#" * round(charge / scale_val) + ":" * round(
        (100 - charge) / scale_val
    )

    charge = "{:.0f}".format(charge)
    if color is not None:
        charge = "<fc={}>{}</fc>".format(color, charge)

    status = b.status
    if status == "Charging":
        ac_status = args.on_ac_status
        leftipat = args.on_icon_pattern
    elif status == "Discharging":
        ac_status = args.off_ac_status
        leftipat = args.off_icon_pattern
    elif status == "AC Idle":
        ac_status = args.idle_ac_status
        leftipat = args.idle_icon_pattern

    # TODO: do something with pattern

    template = args.template
    # replace acstatus/leftipat first - if they contain <variables> they will be replaced
    template = template.replace("<acstatus>", ac_status)
    template = template.replace("<leftipat>", leftipat)
    template = template.replace("<watts>", "{:.1f}".format(b.watts))
    template = template.replace("<left>", charge)
    template = template.replace("<leftbar>", leftbar)
    template = template.replace("<timeleft>", b.time_left_readable)
    template = template.replace("<health>", b.health_percent_readable)

    print(template, end="")


