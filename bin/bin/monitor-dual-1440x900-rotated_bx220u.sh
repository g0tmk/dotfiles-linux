# configure displays for a dual monitor setup with a rotated 1440x900 secondary

xrandr --output HDMI-1 --auto --rotate right --left-of LVDS-1

sleep 1

# TODO: change stalonetray config if necessary
killall stalonetray
stalonetray &

sleep 1

ln -sf ~/.xmobarrc-dual-1440x900-rotated ~/.xmobarrc
xmonad --restart

sleep 1

killall synergyc
killall synergy  # maybe don't need this
~/start-synergy.sh

sleep 1

# reload wallpaper
~/.fehbg

# todo: figure out why this needs to be run twice
xmonad --restart


