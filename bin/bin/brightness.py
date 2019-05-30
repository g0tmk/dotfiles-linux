#!/usr/bin/env python
from __future__ import print_function
import sys

def usage():
    print("{} ( set | increase | decrease ) percent".format(sys.argv[0]))
    sys.exit(1)

def read_file(filename):
    with open(filename, 'r') as f:
        return f.read()

class BrightnessControl():
    def __init__(self):
        self._prefix = "/sys/class/backlight/intel_backlight/"
        self.max_brightness = int(read_file(self._prefix + "max_brightness"))

    @property
    def current_brightness(self):
        return int(read_file(self._prefix + "brightness"))

    @property
    def current_brightness_percent(self):
        return 100 * self.current_brightness / self.max_brightness

    def print_display(self):
        bar_width = 10
        empty_bar_chars = ":" * int((100 - self.current_brightness_percent) / (100 / bar_width))
        filled_bar_chars = "#" * int(self.current_brightness_percent / (100 / bar_width))
        brightness_bar = filled_bar_chars + empty_bar_chars
        
        print("{}{: 6}%".format(brightness_bar, self.current_brightness_percent))

    def set(self, percent):
        if percent > 100:
            percent = 100
        if percent < 0:
            percent = 0

        if percent == 0:
            new_value = 1
        else:
            new_value = int(self.max_brightness * (percent / 100.0))

        with open(self._prefix + "brightness", 'w') as f:
            f.write(str(new_value))

        self.print_display()

    def increase(self, percent):
        percent_new = self.current_brightness_percent + percent
        self.set(percent_new)

    def decrease(self, percent):
        self.increase(-percent)

try:
    op = sys.argv[1]
    perc_delta = int(sys.argv[2])
except IndexError:
    usage()

b = BrightnessControl()

if op == "set":
    b.set(perc_delta)
elif op == "increase":
    b.increase(perc_delta)
elif op == "decrease":
    b.decrease(perc_delta)
else:
    usage()


