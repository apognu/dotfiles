#!/bin/sh

KIND="$1"
UUID="$(uuidgen -r)"

source ~/.secrets.env

if [ "$KIND" == 'full' ]; then
  scrot /tmp/${UUID}.png
elif [ "$KIND" == 'region' ]; then
  scrot -s /tmp/${UUID}.png
else
  exit 1
fi

mc cp /tmp/${UUID}.png personal/screenshots/

URL="$(mc -q --json share download \
  --expire 24h \
  personal/screenshots/${UUID}.png | jq -r '.share')"

ID="$(curl -XPOST \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer ${API_TOKEN}" \
  -d "{\"url\": \"${URL}\"}" \
  https://popineau.eu/link | jq -r '.id')"

echo -n "https://popineau.eu/link/${ID}" | xclip -selection clipboard
