#!/bin/sh

exec 2> /dev/null

if [ $(cat /sys/class/net/lan/carrier) -eq 1 ]; then
  OUT=" $(ip address show lan | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)"
fi

KILLED="$(rfkill list 1 | grep 'Soft blocked' | awk '{print $3}')"
if [ "$KILLED" == 'yes' ]; then
  echo "$OUT  Wireless off"
  exit 0
fi

SSID="$(iwgetid -r)"

if [ $? -eq 0 ]; then
  STR=" $(ip address show wlan | grep 'inet ' | awk '{print $2}' | cut -d/ -f1) [$SSID]"

  if [ -z "$OUT" ]; then
    OUT="$STR"
  else
    OUT="${OUT} ${STR}"
  fi
fi

if [ -z "$OUT" ]; then
  OUT=' No network'
fi

echo $OUT
