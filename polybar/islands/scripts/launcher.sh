#!/usr/bin/env bash

# ┌────────────────────────────────────────────────────────────┐
# │ POLYBAR ISLANDS - Application Launcher Script              │
# │ Uses rofi as application launcher                          │
# └────────────────────────────────────────────────────────────┘

dir="$HOME/.config/polybar/islands/scripts/rofi"

# Launch rofi with custom theme
rofi -show drun \
    -theme "$dir/launcher.rasi" \
    -show-icons \
    -icon-theme "Papirus" \
    -display-drun "Apps"
