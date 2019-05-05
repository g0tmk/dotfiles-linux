#!/usr/bin/env python
from __future__ import print_function
import sys

def usage():
    print("{} ( set | increase | decrease ) percent".format(sys.argv[0]))
    sys.exit(1)

def read_file(filename):
    with open(filename, 'r') as f:
        return f.read()

try:
    op = sys.argv[1]
    perc_delta = int(sys.argv[2])
except IndexError:
    usage()

_prefix = "/sys/class/backlight/intel_backlight/"
max_brightness = int(read_file(_prefix + "max_brightness"))
perc_current = 100 * int(read_file(_prefix + "brightness")) / max_brightness
perc_min = 5

if op == "set":
    perc_new = perc_delta
elif op == "increase":
    perc_new = perc_current + perc_delta
elif op == "decrease":
    perc_new = perc_current - perc_delta
else:
    usage()

if perc_new > 100:
    perc_new = 100
if perc_new < perc_min:
    perc_new = perc_min

new_value = int((perc_new / 100.0) * max_brightness)
print("old: {}%  new: {}% ({})".format(perc_current, perc_new, new_value))

with open(_prefix + "brightness", 'w') as f:
    f.write(str(new_value))

