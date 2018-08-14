#!/bin/sh

[ ! -x $(which wgctl) ] && (echo '' && exit 0)

TUNNELS="$(sudo wgctl status -s | xargs | tr ' ' '/')"

[ -z "$TUNNELS" ] && echo '' && exit 0

echo " ${TUNNELS}"

