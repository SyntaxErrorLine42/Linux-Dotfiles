#!/usr/bin/env bash

# ┌────────────────────────────────────────────────────────────┐
# │ POLYBAR ISLANDS - Bluetooth Status Script                  │
# │ Shows bluetooth status and connected devices               │
# └────────────────────────────────────────────────────────────┘

# Check if bluetooth controller exists
if ! command -v bluetoothctl &> /dev/null; then
    echo "󰂲"
    exit 0
fi

# Check if bluetooth is powered on
power_status=$(bluetoothctl show 2>/dev/null | grep "Powered:" | awk '{print $2}')

if [[ "$power_status" == "yes" ]]; then
    # Check for connected devices
    connected_devices=$(bluetoothctl devices Connected 2>/dev/null | wc -l)
    
    if [[ $connected_devices -gt 0 ]]; then
        # Get first connected device name
        device_name=$(bluetoothctl devices Connected 2>/dev/null | head -1 | cut -d' ' -f3-)
        echo "%{T2}󰂱%{T-} $device_name"
    else
        echo "%{T2}󰂯%{T-}"
    fi
else
    echo "%{T2}󰂲%{T-}"
fi
