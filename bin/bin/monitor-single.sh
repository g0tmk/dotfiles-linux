# configure displays for the single built-in display (1366x768)

echo "use setup_external_monitor instead"

xrandr --output HDMI-1 --off
sleep 1

# TODO: change stalonetray config if necessary
#killall stalonetray
#stalonetray &
#sleep 1

#ln -sf ~/.xmobarrc-single ~/.xmobarrc
xmonad --restart
sleep 1

#killall synergyc
#killall synergy  # maybe don't need this
#~/start-synergy.sh
#sleep 1

# reload wallpaper
~/.fehbg
sleep 1

# todo: figure out why this needs to be run twice
xmonad --restart

