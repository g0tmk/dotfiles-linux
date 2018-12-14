#!/bin/zsh


FG='#ffffff' 
BG='#000000' 

#FONT='-*-*-*-*-*-*-12-*-*-*-*-*-*-*' 
#FONT='ProggySquareTT-12:antialias=no' 
#FONT='Vera-8:antialias=no' 
#FONT='-*-terminus-*-r-normal-*-10-*-*-*-*-*-iso8859-*'
#FONT='DejaVu Sans Mono:pixelsize=11:style=Book:antialias=false' 
FONT='Terminus:pixelsize=12:style=Regular'

SCREEN_WIDTH=$(xrandr | grep -Po --color=never "(?<=\ connected )[\d]+(?=x[\d]+)")

# TRAY_SIZE="48"
TRAY_SIZE="4"

XLOC=$(echo ${SCREEN_WIDTH} - 700 - ${TRAY_SIZE} | bc)

#conky -c ~/.conky/conkyrc | dzen2 -x ${XLOC} -h 16 -fn inconsolata-10 -y 0 -w 700 -ta r -fg #ffffff -bg #000000
#conky -c ~/.conky/conkyrc | dzen2 -x ${XLOC} -h 16 -fn 'fixed' -y 0 -w 700 -ta r -fg #ffffff -bg #000000
conky -c ~/.conky/conkyrc | dzen2 -x ${XLOC} -h 16 -y 0 -w 700 -ta r -fn $FONT -fg $FG -bg $BG 

