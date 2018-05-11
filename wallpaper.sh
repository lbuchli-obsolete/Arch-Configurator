#!/bin/bash

SIZE=$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')
WIDTH=$(echo $SIZE | sed -r 's/x.*//')
HEIGHT=$(echo $SIZE | sed -r 's/.*x//')

wget -O ~/.config/i3/assets/wallpaper.jpg https://unsplash.it/$WIDTH/$HEIGHT/?random

feh --bg-scale ~/.config/i3/assets/wallpaper.jpg
