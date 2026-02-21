#!/bin/bash
# Universal Smart Display Manager for i3 / Linux
# - Detects laptop (eDP) vs desktop
# - Auto-detects ALL monitors
# - Internal laptop monitor can have a manual Hz override
# - ALL external monitors always get their highest possible Hz
# - Forces mode + refresh to avoid Xorg/Picom/i3 ignoring refresh change
# - Choose between EXTEND mode and MIRROR mode

# -----------------------------
# 0. SETTINGS
# -----------------------------
# Set this ONLY if you want to force a fixed Hz for the laptop screen.
# Leave empty "" to auto-detect the highest rate.
LAPTOP_MANUAL_RATE="75"

# Choose display mode:
# MIRROR_MODE=true  → Mirror all displays
# MIRROR_MODE=false → Extend display to the right
MIRROR_MODE=true


# -----------------------------
# 1. Detect internal laptop display (eDP)
# -----------------------------
INTERNAL=$(xrandr | grep " connected" | grep -oP '^eDP-[0-9]+')
if [ -z "$INTERNAL" ]; then
    echo "Laptop panel (eDP) not found → Desktop mode."
    INTERNAL=$(xrandr | grep " connected" | head -n 1 | awk '{print $1}')
fi

echo "Internal display detected: $INTERNAL"


# -----------------------------
# 2. List ALL connected monitors
# -----------------------------
MONITORS=($(xrandr | grep " connected" | awk '{print $1}'))
echo "Detected monitors: ${MONITORS[@]}"


# -----------------------------
# 3. Get highest refresh rate
# -----------------------------
get_max_refresh() {
    local MON=$1

    local RATE=$(xrandr | sed -n "/^$MON connected/,/^[A-Za-z0-9-]\+ connected/p" \
        | grep -oP '\d+x\d+\s+\K[\d.]+' \
        | sort -nr | head -n 1)

    [ -z "$RATE" ] && RATE=60
    echo "$RATE"
}


# -----------------------------
# 4. Build xrandr command
# -----------------------------
POSITIONED="$INTERNAL"
COMMAND="xrandr"

for MON in "${MONITORS[@]}"; do
    RATE=$(get_max_refresh "$MON")

    # Manual override for laptop
    if [ "$MON" == "$INTERNAL" ] && [ -n "$LAPTOP_MANUAL_RATE" ]; then
        echo "Manual override: Laptop → ${LAPTOP_MANUAL_RATE}Hz"
        RATE="$LAPTOP_MANUAL_RATE"
    else
        echo "Monitor $MON → auto max refresh: ${RATE}Hz"
    fi

    # Always define internal monitor
    if [ "$MON" == "$INTERNAL" ]; then
        COMMAND+=" --output $MON --primary --mode 1920x1080 --rate $RATE"
        continue
    fi

    # -----------------------------
    # MIRROR MODE
    # -----------------------------
    if [ "$MIRROR_MODE" = true ]; then
        echo "Mirroring $MON → $INTERNAL"
        COMMAND+=" --output $MON --mode 1920x1080 --rate $RATE --same-as $INTERNAL"
        continue
    fi

    # -----------------------------
    # EXTEND MODE
    # -----------------------------
    echo "Extending $MON → right of $POSITIONED"
    COMMAND+=" --output $MON --mode 1920x1080 --rate $RATE --right-of $POSITIONED"
    POSITIONED="$MON"
done


# -----------------------------
# 5. Execute final command
# -----------------------------
echo ""
echo "Executing:"
echo "$COMMAND"
echo ""

bash -c "$COMMAND"

