#!/usr/bin/env bash

if command -v zenity >/dev/null 2>&1; then
  zenity --calendar &
  exit 0
fi

if command -v notify-send >/dev/null 2>&1; then
  notify-send "Zenity not found" "Install zenity to open the calendar."
fi
