#!/usr/bin/env bash

# ┌────────────────────────────────────────────────────────────┐
# │ POLYBAR ISLANDS - Notification Status Script               │
# │ Shows dunst notification status (paused/active)            │
# └────────────────────────────────────────────────────────────┘

# Check if dunst is running
if ! pgrep -x dunst > /dev/null; then
    echo "󰂛"
    exit 0
fi

# Check if notifications are paused
if command -v dunstctl &> /dev/null; then
    paused=$(dunstctl is-paused)
    count=$(dunstctl count waiting)
    
    if [[ "$paused" == "true" ]]; then
        if [[ $count -gt 0 ]]; then
            echo "󰂛 $count"
        else
            echo "󰂛"
        fi
    else
        if [[ $count -gt 0 ]]; then
            echo "󰂚 $count"
        else
            echo "󰂜"
        fi
    fi
else
    echo "󰂜"
fi
