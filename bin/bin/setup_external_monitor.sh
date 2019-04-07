#!/bin/bash
# Automatically setup external monitor

xrandr_command="/usr/bin/xrandr"
sed_command="/bin/sed"
extra_params=""

if [ "$1" = "--rotate" ]; then
    echo "rotating external display right"
    extra_params+=" --rotate right"
else
    echo "skip external display rotation"
fi

is_hdmi_connected=`DISPLAY=:0 $xrandr_command | $sed_command -n '/HDMI1 connected/p'`

if [ -n "$is_hdmi_connected" ]; then
  DISPLAY=:0 $xrandr_command --output HDMI1 --auto --left-of eDP1 $extra_params
else
  DISPLAY=:0 $xrandr_command --output HDMI1 --off
fi


is_dp_connected=`DISPLAY=:0 $xrandr_command | $sed_command -n '/DP1 connected/p'`

if [ -n "$is_dp_connected" ]; then
  DISPLAY=:0 $xrandr_command --output DP1 --auto --left-of eDP1 $extra_params
else
  DISPLAY=:0 $xrandr_command --output DP1 --off
fi


# re-init some settings since changing monitor config breaks:
#  wallpaper tiling
#  conky location
sleep 2
sh ~/.fehbg &
killall -SIGUSR1 conky
