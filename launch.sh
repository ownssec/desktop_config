#!/bin/bash

killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Detection
export MONITOR=$(xrandr --query | grep " connected primary" | cut -d" " -f1)
[ -z "$MONITOR" ] && export MONITOR=$(xrandr --query | grep " connected" | head -n1 | cut -d" " -f1)

# Launch (Removing the dots after disown)
polybar config --config="$HOME/.config/polybar/config.ini" &
sleep 0.5
# polybar bottomPanel --config="$HOME/.config/polybar/configPanelBottom.ini" &

disown
