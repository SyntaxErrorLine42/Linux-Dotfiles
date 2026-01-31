#!/usr/bin/env bash

# ┌────────────────────────────────────────────────────────────┐
# │ POLYBAR ISLANDS - Notification Status Script               │
# │ Shows XFCE4-notifyd status (DND mode indicator)            │
# └────────────────────────────────────────────────────────────┘

# Check if XFCE4-notifyd is running
if ! pgrep -x xfce4-notifyd > /dev/null; then
    echo "󰂛"
    exit 0
fi

# Check DND mode using xfconf
dnd_enabled=$(xfconf-query -c xfce4-notifyd -p /do-not-disturb 2>/dev/null)

if [[ "$dnd_enabled" == "true" ]]; then
    echo "󰂛"
else
    echo ""
fi
