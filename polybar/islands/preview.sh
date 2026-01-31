#!/usr/bin/env bash

# ┌────────────────────────────────────────────────────────────┐
# │ POLYBAR ISLANDS - Preview Script                           │
# │ Quick preview of the islands theme                         │
# └────────────────────────────────────────────────────────────┘

DIR="$HOME/.config/polybar/islands"

# Kill any existing polybar instances
killall -q polybar

# Wait for them to shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.5; done

# Launch the preview
polybar -q main -c "$DIR"/config.ini &

echo "Islands theme preview launched!"
echo "Press Ctrl+C to stop, or run 'killall polybar' to close."
