#!/bin/bash

xbacklight -set 20 &
xautolock -time 10 -locker i3lock-fancy &
xset dpms 600 600 600
polybar &
nordvpn c &
thunderbird &
firefox &
alacritty &
insync start &
