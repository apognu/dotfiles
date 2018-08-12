#!/bin/sh

vault seal
pkill gpg-agent
SSH_AUTH_SOCK=/run/user/$(id -u)/ssh-agent.socket ssh-add -D

i3lock -i /home/apognu/Documents/wallpaper.png -t -k --ringcolor=07364295 --keyhlcolor=268bd295 --bshlcolor=dc322f95 --insidecolor=002b3695 --insidevercolor=268bd295 --ringvercolor=268bd295 --insidewrongcolor=dc322f95 --ringwrongcolor=dc322f95 --linecolor=07364295 --separatorcolor=07364295 --datecolor=268bd295 --date-font=Roboto --time-font=Roboto --timecolor=dc322f95
