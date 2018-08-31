#!/bin/sh

ESSIDS="$(iwctl known-networks list | tail -n +5 | head -n-1 | awk '{print $1}')"
ESSID="$(echo "$ESSIDS" | dmenu -p 'Connect to network...')"

[ -z "$ESSID" ] && exit 0

iwctl device wlan scan
iwctl device wlan disconnect
iwctl device wlan connect $ESSID

