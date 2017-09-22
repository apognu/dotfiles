#!/bin/sh

MENU=(
  'Power off'
  'Sign out'
  'Reboot'
  'Suspend'
)

CHOICE=$(printf '%s\n' "${MENU[@]}" | rofi -dmenu -i -p '  Power management: ')

case "$CHOICE" in
  'Sign out')
    SESSION="$(loginctl -p Sessions show-user $USER | cut -d'=' -f2 | cut -d' ' -f1)"
    loginctl terminate-session $SESSION
    ;;

  'Power off')
    systemctl poweroff
    ;;

  'Reboot')
    systemctl reboot
    ;;

  'Suspend')
    systemctl suspend
    ;;
esac
