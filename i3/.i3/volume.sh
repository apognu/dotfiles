#!/bin/sh

COMMAND="$1"
ARG=''
SINKS=$(pactl list short sinks | grep -v SUSPENDED | awk '{print $2}')

case "$1" in
  'up')
    COMMAND='set-sink-volume'
    ARG='+5%'
    ;;

  'down')
    COMMAND='set-sink-volume'
    ARG='-5%'
    ;;

  'mute')
    COMMAND='set-sink-mute'
    ARG='toggle'
    ;;

  *) exit 0 ;;
esac

for SINK in $SINKS; do
  pactl "$COMMAND" "$SINK" "$ARG"
done

if [ "$(pamixer --get-mute)" == 'true' ]; then
  volnoti-show -m
else
  volnoti-show "$(pamixer --get-volume)"
fi
