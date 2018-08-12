#!/bin/sh

ffmpeg -f x11grab -video_size 1920x1080 -y -i $DISPLAY -filter_complex "boxblur=2:1" -vframes 1 /tmp/lock.png

SIGN_ADD_COLOR=2980b9ff
SIGN_DEL_COLOR=e67e22ff
PASSWORD_OK=1abc9cff
PASSWORD_KO=e67e22ff
BACKGROUND=00000000
FOREGROUND=ffffffff

convert /tmp/lock.png -draw "fill rgba(0, 0, 0, 0.4) rectangle 30,970 330,1060" /tmp/lock.png
# rectangle $CX,$CY $((CX+300)),$((CY-80)) 

i3lock \
  -t -i /tmp/lock.png \
  --timepos="x+90:h-70" \
  --datepos="x+135:h-45" \
  --clock --datestr "Type password to unlock..." \
  --insidecolor=$BACKGROUND --ringcolor=$FOREGROUND --line-uses-inside \
  --keyhlcolor=$SIGN_ADD_COLOR --bshlcolor=$SIGN_DEL_COLOR --separatorcolor=$BACKGROUND \
  --insidevercolor=$PASSWORD_OK --insidewrongcolor=$PASSWORD_KO \
  --ringvercolor=$FOREGROUND --ringwrongcolor=$FOREGROUND --indpos="x+280:h-65" \
  --radius=20 --ring-width=2 --veriftext="" --wrongtext="" \
  --verifcolor="$FOREGROUND" --timecolor="$FOREGROUND" --datecolor="$FOREGROUND" \
  --timesize=22 \
  --noinputtext="" --force-clock $lockargs
