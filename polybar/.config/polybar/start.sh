#!/bin/sh

pkill polybar

for MONITOR in $(polybar -m | awk -F: '{print $1}'); do
  MONITOR=$MONITOR polybar bottombar &
done
