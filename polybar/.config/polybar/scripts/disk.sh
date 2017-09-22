#!/bin/sh

USED=$(btrfs filesystem usage -b / 2> /dev/null | grep Used | awk '{print $2}')
FREE=$(btrfs filesystem usage -b / 2> /dev/null | grep Free | awk '{print $3}')
SIZE=$(btrfs filesystem usage -b / 2> /dev/null | grep 'Device size' | awk '{print $3}')

RATE=$(echo "$USED / $SIZE * 100" | bc -l)

echo " $(printf '%.1f' $RATE)%"
