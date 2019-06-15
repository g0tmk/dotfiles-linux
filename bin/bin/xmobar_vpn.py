#!/usr/bin/env python3
"""Print vpn info with parameters similar to other xmobar plugins.

"""

from __future__ import print_function
import subprocess
import re
import sys


def run_command(cmd):
    """Run a command and return its stdout as a string. Command must be passed
    as a list of parameters ie ['ls', '-la']"""
    return subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL).stdout.decode('utf-8')

def read_file(filename):
    with open(filename, 'r') as f:
        return f.read()


class VPNStatus():
    def __init__(self):
        pass

    @property
    def status(self):
        return "Connected" if self._vpn_is_connected() else "Disconnected"

    @property
    def name(self):
        return "ecliptic"

    def _vpn_is_connected(self):
        return True


if __name__ == "__main__":
    import argparse

    # Initialize arg parser. Note since we override -h, add_help must be false
    p = argparse.ArgumentParser(
        description="Print VPN status for xmobar", add_help=False
    )
    p.add_argument(
        "--show-debug-info",
        default=False,
        action="store_true",
        help="If true output all information to stdout.",
    )
    p.add_argument(
        "-t",
        "--template",
        default="VPN: <name> <vpnstatus>",
        type=str,
        metavar="TEMPLATE",
        help=(
            "Output template. Allowed values: name, name_short, vpnstatus."
        ),
    )
    p.add_argument(
        "-O",
        "--on-vpn-status",
        default="Connected",
        type=str,
        metavar="TEMPLATE",
        help=(
            'String for VPN "on" status (default: "Connected").'
        ),
    )
    p.add_argument(
        "-i",
        "--off-vpn-status",
        default="Disconnected",
        type=str,
        metavar="TEMPLATE",
        help=(
            'String for VPN "off" status (default: "Disconnected").'
        )
    )

    # Add explicit --help arg, since -h arg is disabled.
    # TODO: figure out why this does not work
    # p.add_argument('--help', action='help', help='show this help message and exit')
    
    args = p.parse_args(args=[x for x in sys.argv[1:] if x != "--"])

    try:
        v = VPNStatus()
    except Exception as e:
        print("Can't get VPN status")
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

    status = v.status
    if status == "Connected":
        vpn_status = args.on_vpn_status
    elif status == "Disconnected":
        vpn_status = args.off_vpn_status

    template = args.template
    # replace acstatus/leftipat first - if they contain <variables> they will be replaced
    template = template.replace("<vpnstatus>", vpn_status)
    template = template.replace("<name>", v.name)
    template = template.replace("<name_short>", v.name[:3])

    print(template, end="")

