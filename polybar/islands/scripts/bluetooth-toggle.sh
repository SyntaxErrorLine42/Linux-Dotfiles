#!/usr/bin/env bash

# ┌────────────────────────────────────────────────────────────┐
# │ POLYBAR ISLANDS - Bluetooth Toggle Script                  │
# │ Toggle bluetooth power on/off                              │
# └────────────────────────────────────────────────────────────┘

# Check if bluetooth controller exists
if ! command -v bluetoothctl &> /dev/null; then
    notify-send "Bluetooth" "bluetoothctl not found" -i bluetooth
    exit 1
fi

# Get current power status
power_status=$(bluetoothctl show 2>/dev/null | grep "Powered:" | awk '{print $2}')

if [[ "$power_status" == "yes" ]]; then
    bluetoothctl power off
    notify-send "Bluetooth" "Turned off" -i bluetooth-disabled
else
    bluetoothctl power on
    notify-send "Bluetooth" "Turned on" -i bluetooth-active
fi
