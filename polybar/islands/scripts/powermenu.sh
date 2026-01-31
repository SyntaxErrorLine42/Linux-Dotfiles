#!/usr/bin/env bash

# ┌────────────────────────────────────────────────────────────┐
# │ POLYBAR ISLANDS - Power Menu Script                        │
# │ Uses rofi for a beautiful power menu                       │
# └────────────────────────────────────────────────────────────┘

dir="$HOME/.config/polybar/islands/scripts/rofi"

# Get uptime in a cleaner format
uptime_info=$(uptime -p | sed -e 's/up //g' -e 's/ hours\?/h/g' -e 's/ minutes\?/m/g' -e 's/ days\?/d/g' -e 's/,//g')

# Rofi command with theme
rofi_command="rofi -theme $dir/powermenu.rasi"

# Options with icons
shutdown="󰐥 Shutdown"
reboot="󰜉 Restart"
lock="󰌾 Lock"
suspend="󰒲 Sleep"
logout="󰍃 Logout"

# Confirmation dialog
confirm_exit() {
    rofi -dmenu \
        -i \
        -no-fixed-num-lines \
        -p "Are You Sure? " \
        -theme "$dir/confirm.rasi"
}

# Message notification
msg() {
    rofi -theme "$dir/message.rasi" -e "Options: yes / y / no / n"
}

# Variable passed to rofi
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | $rofi_command -p "Uptime: $uptime_info" -dmenu -selected-row 0)"

case $chosen in
    $shutdown)
        ans=$(confirm_exit &)
        if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
            systemctl poweroff
        elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
            exit 0
        else
            msg
        fi
        ;;
    $reboot)
        ans=$(confirm_exit &)
        if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
            systemctl reboot
        elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
            exit 0
        else
            msg
        fi
        ;;
    $lock)
        # Try various lock programs
        if [[ -f /usr/bin/betterlockscreen ]]; then
            betterlockscreen -l
        elif [[ -f /usr/bin/i3lock ]]; then
            i3lock -c 1a1a1a
        elif [[ -f /usr/bin/swaylock ]]; then
            swaylock -c 1a1a1a
        fi
        ;;
    $suspend)
        ans=$(confirm_exit &)
        if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
            # Mute audio and pause media before sleep
            playerctl pause 2>/dev/null
            amixer set Master mute 2>/dev/null
            systemctl suspend
        elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
            exit 0
        else
            msg
        fi
        ;;
    $logout)
        ans=$(confirm_exit &)
        if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
            if [[ "$DESKTOP_SESSION" == "i3" ]]; then
                i3-msg exit
            elif [[ "$DESKTOP_SESSION" == "bspwm" ]]; then
                bspc quit
            elif [[ "$DESKTOP_SESSION" == "openbox" ]]; then
                openbox --exit
            elif [[ "$DESKTOP_SESSION" == "hyprland" ]]; then
                hyprctl dispatch exit
            elif [[ "$DESKTOP_SESSION" == "sway" ]]; then
                swaymsg exit
            else
                loginctl terminate-user $USER
            fi
        elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
            exit 0
        else
            msg
        fi
        ;;
esac
