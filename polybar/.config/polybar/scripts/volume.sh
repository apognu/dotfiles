#!/bin/sh

pamixer --get-mute > /dev/null && echo '%{u#f2784b}%{F#f2784b} Muted' && exit 0

echo "%{u#16A085} $(pamixer --get-volume)%"
