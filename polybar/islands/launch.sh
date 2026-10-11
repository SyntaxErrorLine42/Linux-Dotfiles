#!/usr/bin/env bash

# ┌────────────────────────────────────────────────────────────┐
# │ POLYBAR ISLANDS THEME - Launch Script                      │
# │ Floating island-style bar with rounded corners             │
# └────────────────────────────────────────────────────────────┘

DIR="$HOME/.config/polybar/islands"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Connectivity check for weather islands
online() {
  curl -sf --max-time 5 -o /dev/null https://1.1.1.1 || return 1
}

# Launch spacer bar first (reserves space for windows)

# Launch visual island bars
polybar -q left -c "$DIR"/config.ini &
if online; then
  polybar -q weather -c "$DIR"/config.ini &
  polybar -q weather-tomorrow -c "$DIR"/config.ini &
else
  echo "Offline - skipping weather islands"
fi
polybar -q center -c "$DIR"/config.ini &
polybar -q right -c "$DIR"/config.ini &
polybar -q date -c "$DIR"/config.ini &
polybar -q power -c "$DIR"/config.ini &

echo "Polybar Islands launched..."
