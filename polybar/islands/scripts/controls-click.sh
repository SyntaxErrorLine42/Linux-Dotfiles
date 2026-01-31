#!/usr/bin/env bash

# ┌────────────────────────────────────────────────────────────┐
# │ POLYBAR ISLANDS - Controls Click Handler                   │
# │ Handles clicks on the controls island                      │
# └────────────────────────────────────────────────────────────┘

action=$1

if [[ "$action" == "left" ]]; then
    # Left click - open network manager or settings
    if command -v nm-connection-editor &> /dev/null; then
        nm-connection-editor &
    elif command -v gnome-control-center &> /dev/null; then
        gnome-control-center network &
    fi
elif [[ "$action" == "right" ]]; then
    # Right click - open sound settings or pavucontrol
    if command -v pavucontrol &> /dev/null; then
        pavucontrol &
    elif command -v gnome-control-center &> /dev/null; then
        gnome-control-center sound &
    fi
fi
