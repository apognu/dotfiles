#!/bin/sh

TUNNELS="$(sudo wgctl status -s | xargs | tr ' ' '/')"

[ -z "$TUNNELS" ] && echo '' && exit 0

echo " ${TUNNELS}"

