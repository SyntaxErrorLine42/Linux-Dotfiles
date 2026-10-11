#!/usr/bin/env bash

# ┌────────────────────────────────────────────────────────────┐
# │ POLYBAR ISLANDS - Weather Script                          │
# │ Nerd Font weather icon + day/night temp + city via wttr.in │
# │ Usage: weather.sh [today|tomorrow]                        │
# └────────────────────────────────────────────────────────────┘

DAY="${1:-today}"

json="$(curl -s --max-time 8 "https://wttr.in/?format=j1")"
[[ -z "$json" ]] && exit 1

city="$(curl -s --max-time 8 "https://wttr.in/?format=%l" | cut -d, -f1)"
[[ -z "$city" ]] && exit 1

JSON="$json" CITY="$city" python3 -c '
import sys, os, json

load = json.loads(os.environ["JSON"])
weather = load["weather"]
city = os.environ["CITY"]


def temp_str(t):
    v = int(round(float(t)))
    return f"+{v}\u00b0C" if v > 0 else f"{v}\u00b0C"


def icon(cond):
    c = cond.lower()
    if "thunder" in c or "lightning" in c:
        return "\ue31d"
    if "tornado" in c:
        return "\ue351"
    if "hurricane" in c:
        return "\ue36c"
    if "snow" in c or "blizzard" in c or "ice pellet" in c:
        return "\ue31a"
    if "hail" in c or "sleet" in c:
        return "\ue314"
    if "rain" in c or "drizzle" in c or "shower" in c:
        return "\ue318"
    if "fog" in c or "mist" in c:
        return "\ue313"
    if "smoke" in c or "haze" in c:
        return "\ue35c"
    if "dust" in c or "sand" in c:
        return "\ue35d"
    if "wind" in c:
        return "\ue31e"
    if "cloudy" in c or "overcast" in c:
        return "\ue312"
    return "\ue30d"


if sys.argv[1] == "tomorrow" and len(weather) > 1:
    day = weather[1]
    temp = day["maxtempC"]
    night = day["mintempC"]
    cond = day["hourly"][4]["weatherDesc"][0]["value"]
else:
    cur = load["current_condition"][0]
    temp = cur["temp_C"]
    night = weather[0]["mintempC"]
    cond = cur["weatherDesc"][0]["value"]

print("%%{T4}%s%%{T-}  %s/%s, %s" % (icon(cond), temp_str(temp), temp_str(night), city))
' "$DAY"
