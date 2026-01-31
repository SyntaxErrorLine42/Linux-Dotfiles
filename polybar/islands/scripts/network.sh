#!/usr/bin/env bash

# ┌────────────────────────────────────────────────────────────┐
# │ POLYBAR ISLANDS - Network Status Script                    │
# │ Shows ethernet icon when wired, wifi signal when wireless  │
# └────────────────────────────────────────────────────────────┘

# Check for ethernet connection first (override wifi)
# Common ethernet interface names: eth0, enp*, eno*, enx*
for iface in /sys/class/net/en* /sys/class/net/eth*; do
    if [[ -d "$iface" ]]; then
        iface_name=$(basename "$iface")
        # Check if interface is up and has carrier (cable connected)
        if [[ -f "$iface/operstate" ]]; then
            state=$(cat "$iface/operstate" 2>/dev/null)
            if [[ "$state" == "up" ]]; then
                echo "%{T2}󰈀%{T-}"
                exit 0
            fi
        fi
    fi
done

# No ethernet, check wifi
wifi_iface="wlp2s0"

if [[ -d "/sys/class/net/$wifi_iface" ]]; then
    state=$(cat "/sys/class/net/$wifi_iface/operstate" 2>/dev/null)
    
    if [[ "$state" == "up" ]]; then
        # Get signal strength
        if command -v iwconfig &> /dev/null; then
            signal=$(iwconfig "$wifi_iface" 2>/dev/null | grep -oP 'Signal level=\K-\d+' | tr -d '-')
        elif [[ -f "/proc/net/wireless" ]]; then
            signal=$(awk "/$wifi_iface/ {print int(\$3)}" /proc/net/wireless 2>/dev/null)
        else
            signal=70  # Default if can't read
        fi
        
        # Convert signal to icon (signal is in negative dBm, lower absolute = better)
        # Typical range: -30 (excellent) to -90 (very weak)
        if [[ -z "$signal" ]]; then
            echo "%{T2}󰤨%{T-}"
        elif [[ $signal -le 30 ]]; then
            echo "%{T2}󰤨%{T-}"  # Excellent
        elif [[ $signal -le 50 ]]; then
            echo "%{T2}󰤥%{T-}"  # Good
        elif [[ $signal -le 60 ]]; then
            echo "%{T2}󰤢%{T-}"  # Fair
        elif [[ $signal -le 70 ]]; then
            echo "%{T2}󰤟%{T-}"  # Weak
        else
            echo "%{T2}󰤯%{T-}"  # Very weak
        fi
    else
        echo "%{T2}󰤭%{T-}"  # Disconnected
    fi
else
    echo "%{T2}󰤮%{T-}"  # No interface
fi
