#!/bin/sh

UNITS="$*"
OUT=''

for UNIT in $UNITS; do
  if systemctl status openvpn-client@${UNIT} &> /dev/null; then
    if [ -z "$OUT" ]; then
      OUT=" $UNIT"
    else
      OUT="${OUT}/$UNIT"
    fi
  fi
done

echo $OUT
