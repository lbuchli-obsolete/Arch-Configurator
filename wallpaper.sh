#!/bin/bash

SIZE=$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')
WIDTH=$(echo $SIZE | sed -r 's/x.*//')
HEIGHT=$(echo $SIZE | sed -r 's/.*x//')

LINK=https://unsplash.it/$WIDTH/$HEIGHT/?random

NBR=$((1 + RANDOM % 10))

wget -q --spider $LINK

if [ $? -eq 0 ]; then
    wget --tries=5 -O ~/.config/i3/assets/wallpaper$NBR.jpg $LINK
else echo "No internet connection."; fi

feh --bg-scale ~/.config/i3/assets/wallpaper$NBR.jpg
