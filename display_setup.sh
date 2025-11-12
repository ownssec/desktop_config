#!/bin/bash
# Smart i3 display script — defaults:
# → Laptop (with eDP) = 48 Hz
# → Desktop (no eDP)  = 60 Hz

INTERNAL="eDP-1"    # internal laptop display
EXTERNAL="HDMI-1"   # external monitor

# Check if internal display exists (laptop vs desktop)
if xrandr | grep -q "^$INTERNAL connected"; then
  # Laptop detected → prefer 48 Hz
  DEFAULT_RATE=48
else
  # Desktop detected → prefer 60 Hz
  DEFAULT_RATE=60
fi

# Apply configuration
if xrandr | grep -q "^$EXTERNAL connected"; then
  echo "External display connected → extending desktop at ${DEFAULT_RATE}Hz"
  xrandr --output "$INTERNAL" --primary --mode 1920x1080 --rate "$DEFAULT_RATE" --auto \
         --output "$EXTERNAL" --auto --right-of "$INTERNAL"
else
  echo "External display not connected → using internal at ${DEFAULT_RATE}Hz"
  xrandr --output "$INTERNAL" --primary --mode 1920x1080 --rate "$DEFAULT_RATE" --auto \
         --output "$EXTERNAL" --off
fi

