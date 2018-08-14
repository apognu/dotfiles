#!/usr/bin/sh

which wgctl > /dev/null 2>&1

[ $? -ne 0 ] && echo '' && exit 0

TUNNELS="$(sudo wgctl status -s | xargs | tr ' ' '/')"

[ -z "$TUNNELS" ] && echo '' && exit 0

echo " ${TUNNELS}"

