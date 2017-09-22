#!/bin/sh

STATE_FILE="${HOME}/.config/Google Play Music Desktop Player/json_store/playback.json"

if [ ! -f "$STATE_FILE" ]; then
  echo ""
  exit
fi

STATE=$(cat "$STATE_FILE")

PLAYING="$(echo $STATE | jq -r '.playing')"
ARTIST="$(echo $STATE | jq -r '.song.artist')"
TITLE="$(echo $STATE | jq -r '.song.title')"

if [ "$TITLE" == 'null' ]; then
  echo ""
  exit
fi

if [ "$PLAYING" == 'true' ]; then
  PLAYING=''
else
  PLAYING=''
fi

echo "$PLAYING $ARTIST - $TITLE"
