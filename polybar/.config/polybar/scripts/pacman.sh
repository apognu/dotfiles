#!/bin/sh

# sudo pacman -Sy &> /dev/null

if [ $? -ne 0 ]; then
  exit 0
fi

UPGRADES=$(pacman -Qu | wc -l)

[ $UPGRADES -eq 0 ] && echo ''

OUT="%{u#f2784b} $UPGRADES upgrade"
[ $UPGRADES -gt 1 ] && OUT="${OUT}s "

echo $OUT

exit 0
