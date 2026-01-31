#!/usr/bin/env bash

# ┌────────────────────────────────────────────────────────────┐
# │ POLYBAR ISLANDS - System Updates Script                    │
# │ Check for available updates (supports multiple package mgrs│
# └────────────────────────────────────────────────────────────┘

# Check for updates based on available package manager

get_updates() {
    updates=0
    
    # Arch Linux (pacman + AUR helpers)
    if command -v checkupdates &> /dev/null; then
        arch_updates=$(checkupdates 2>/dev/null | wc -l)
        updates=$((updates + arch_updates))
    fi
    
    # AUR updates (yay)
    if command -v yay &> /dev/null; then
        aur_updates=$(yay -Qua 2>/dev/null | wc -l)
        updates=$((updates + aur_updates))
    fi
    
    # AUR updates (paru)
    if command -v paru &> /dev/null && ! command -v yay &> /dev/null; then
        aur_updates=$(paru -Qua 2>/dev/null | wc -l)
        updates=$((updates + aur_updates))
    fi
    
    # Debian/Ubuntu (apt)
    if command -v apt &> /dev/null; then
        apt_updates=$(apt list --upgradable 2>/dev/null | grep -c upgradable)
        updates=$((updates + apt_updates))
    fi
    
    # Fedora (dnf)
    if command -v dnf &> /dev/null; then
        dnf_updates=$(dnf check-update 2>/dev/null | grep -c "")
        updates=$((updates + dnf_updates))
    fi
    
    echo $updates
}

updates=$(get_updates)

if [[ $updates -eq 0 ]]; then
    echo "0"
else
    echo "$updates"
fi
