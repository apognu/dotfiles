#!/bin/sh

exec > /dev/null 2>&1

export XAUTHORITY=~/.Xauthority
export DISPLAY=:0

SECONDARY="${1:-HDMI1}"

if xrandr | grep 'HDMI1 connected'; then
  xrandr --output $SECONDARY --auto --right-of eDP1
else
  xrandr --output $SECONDARY --off
fi

feh --bg-fill Documents/wallpaper.png

pkill compton
compton --config ~/.config/compton.conf &

i3-msg restart

