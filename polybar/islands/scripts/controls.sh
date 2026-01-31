#!/usr/bin/env bash

# ┌────────────────────────────────────────────────────────────┐
# │ POLYBAR ISLANDS - Controls Island Script                   │
# │ Shows: WiFi, Bluetooth, Battery, Volume, Keyboard Layout   │
# └────────────────────────────────────────────────────────────┘

# WiFi status
get_wifi() {
    wifi_status=$(nmcli -t -f WIFI g 2>/dev/null)
    if [[ "$wifi_status" == "enabled" ]]; then
        essid=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2)
        if [[ -n "$essid" ]]; then
            echo "󰤨"
        else
            echo "󰤭"
        fi
    else
        echo "󰤮"
    fi
}

# Bluetooth status
get_bluetooth() {
    if command -v bluetoothctl &> /dev/null; then
        power_status=$(bluetoothctl show 2>/dev/null | grep "Powered:" | awk '{print $2}')
        if [[ "$power_status" == "yes" ]]; then
            connected=$(bluetoothctl devices Connected 2>/dev/null | wc -l)
            if [[ $connected -gt 0 ]]; then
                echo "󰂱"
            else
                echo "󰂯"
            fi
        else
            echo "󰂲"
        fi
    else
        echo "󰂲"
    fi
}

# Battery status
get_battery() {
    battery_path="/sys/class/power_supply/BAT0"
    if [[ -d "$battery_path" ]]; then
        capacity=$(cat "$battery_path/capacity" 2>/dev/null)
        status=$(cat "$battery_path/status" 2>/dev/null)
        
        if [[ "$status" == "Charging" ]]; then
            echo "󰂄 ${capacity}%"
        elif [[ "$status" == "Full" ]]; then
            echo "󰁹 Full"
        else
            if [[ $capacity -ge 90 ]]; then
                echo "󰂂 ${capacity}%"
            elif [[ $capacity -ge 80 ]]; then
                echo "󰂁 ${capacity}%"
            elif [[ $capacity -ge 70 ]]; then
                echo "󰂀 ${capacity}%"
            elif [[ $capacity -ge 60 ]]; then
                echo "󰁿 ${capacity}%"
            elif [[ $capacity -ge 50 ]]; then
                echo "󰁾 ${capacity}%"
            elif [[ $capacity -ge 40 ]]; then
                echo "󰁽 ${capacity}%"
            elif [[ $capacity -ge 30 ]]; then
                echo "󰁼 ${capacity}%"
            elif [[ $capacity -ge 20 ]]; then
                echo "󰁻 ${capacity}%"
            elif [[ $capacity -ge 10 ]]; then
                echo "󰁺 ${capacity}%"
            else
                echo "󰂎 ${capacity}%"
            fi
        fi
    else
        echo "󰂑"
    fi
}

# Volume status
get_volume() {
    if command -v pactl &> /dev/null; then
        # Get default sink
        default_sink=$(pactl get-default-sink 2>/dev/null)
        if [[ -n "$default_sink" ]]; then
            volume=$(pactl get-sink-volume "$default_sink" 2>/dev/null | grep -oP '\d+%' | head -1 | tr -d '%')
            muted=$(pactl get-sink-mute "$default_sink" 2>/dev/null | grep -oP 'yes|no')
            
            if [[ "$muted" == "yes" ]]; then
                echo "󰖁 Mute"
            elif [[ $volume -ge 70 ]]; then
                echo "󰕾 ${volume}%"
            elif [[ $volume -ge 30 ]]; then
                echo "󰖀 ${volume}%"
            else
                echo "󰕿 ${volume}%"
            fi
        else
            echo "󰖁"
        fi
    elif command -v amixer &> /dev/null; then
        volume=$(amixer get Master 2>/dev/null | grep -oP '\d+%' | head -1 | tr -d '%')
        muted=$(amixer get Master 2>/dev/null | grep -oP '\[off\]' | head -1)
        
        if [[ -n "$muted" ]]; then
            echo "󰖁 Mute"
        elif [[ $volume -ge 70 ]]; then
            echo "󰕾 ${volume}%"
        elif [[ $volume -ge 30 ]]; then
            echo "󰖀 ${volume}%"
        else
            echo "󰕿 ${volume}%"
        fi
    else
        echo "󰖁"
    fi
}

# Keyboard layout
get_keyboard() {
    if command -v xkblayout-state &> /dev/null; then
        layout=$(xkblayout-state print "%s" 2>/dev/null | tr '[:lower:]' '[:upper:]')
    else
        layout=$(setxkbmap -query 2>/dev/null | grep layout | awk '{print $2}' | cut -d',' -f1 | tr '[:lower:]' '[:upper:]')
    fi
    echo "󰌌 ${layout:-US}"
}

# Combine all outputs with spacing
wifi=$(get_wifi)
bluetooth=$(get_bluetooth)
battery=$(get_battery)
volume=$(get_volume)
keyboard=$(get_keyboard)

echo "$wifi  $bluetooth  $battery  $volume  $keyboard"
