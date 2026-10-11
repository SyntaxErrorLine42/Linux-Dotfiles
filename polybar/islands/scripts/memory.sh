#!/usr/bin/env bash

# ┌────────────────────────────────────────────────────────────┐
# │ POLYBAR ISLANDS - Memory Usage Script                      │
# │ Shows used/total RAM in GB to one decimal (e.g. 3.1/9.0)   │
# └────────────────────────────────────────────────────────────┘

awk '
  /^MemTotal:/     { total = $2 }
  /^MemAvailable:/ { avail = $2 }
  END {
    used = (total - avail) / 1048576
    total = total / 1048576
    out = sprintf("%.1f/%.1f", used, total)
    gsub(/\./, ",", out)
    print out
  }
' /proc/meminfo
