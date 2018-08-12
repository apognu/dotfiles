#!/bin/sh

[ -d /sys/class/power_supply/BAT0 ] || (echo '' && exit 0)

RAW_CAPACITY=$(cat /sys/class/power_supply/BAT*/capacity | awk '{ total += $1; count++ } END { print total/count }' | cut -d. -f1)
CAPACITY=$(echo $RAW_CAPACITY | xargs printf "%3d\n")

OUT=''

if [ $RAW_CAPACITY -gt 85 ]; then
  OUT=" ${CAPACITY}%"
elif [ $RAW_CAPACITY -gt 55 ]; then
  OUT=" ${CAPACITY}%"
elif [ $RAW_CAPACITY -gt 25 ]; then
  OUT=" ${CAPACITY}%"
elif [ $RAW_CAPACITY -gt 10 ]; then
  OUT="%{u#f2784b}%{F#f2784b} ${CAPACITY}%"
else
  OUT="%{u#96281b}%{F#96281b} ${CAPACITY}%"
fi

if grep 'Charging' /sys/class/power_supply/BAT*/status > /dev/null; then
  OUT="$OUT "
fi

echo $OUT

