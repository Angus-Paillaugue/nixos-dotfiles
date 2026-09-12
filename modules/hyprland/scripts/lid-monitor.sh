#!/bin/bash

# Kill any other instances of this script to prevent conflicts
for pid in $(pgrep -f "lid-monitor.sh"); do
    if [ "$pid" != "$$" ]; then
        kill "$pid"
    fi
done

LID_PATH="/proc/acpi/button/lid/LID0/state"
MONITOR_NAME="eDP-1"
LOG_FILE="/tmp/lid-monitor.log"

echo "$(date): Starting lid-monitor..." > "$LOG_FILE"

if [[ ! -f "$LID_PATH" ]]; then
  echo "$(date): Lid path $LID_PATH not found. Exiting." >> "$LOG_FILE"
  exit 1
fi

LAST_STATE="unknown"

while true; do
  LID_STATE_TEXT=$(grep -o -i open "$LID_PATH")

  # Check number of monitors excluding the internal one
  # We use || echo 0 to handle cases where jq might fail or return empty
  EXTERNAL_COUNT=$(hyprctl monitors -j | jq "[.[] | select(.name != \"$MONITOR_NAME\")] | length")
  if [[ -z "$EXTERNAL_COUNT" ]]; then
    EXTERNAL_COUNT=0
  fi

  if [[ "$LID_STATE_TEXT" == "open" ]]; then
    TARGET_STATE="open"
  else
    TARGET_STATE="closed"
  fi

  # Safety: If no external monitors are connected, we MUST enable the internal one
  if [[ "$EXTERNAL_COUNT" -eq 0 ]]; then
    TARGET_STATE="open"
  fi

  # Check if the monitor is currently active (enabled) in Hyprland
  IS_ACTIVE=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$MONITOR_NAME\") | .name")

  if [[ "$TARGET_STATE" == "closed" && -n "$IS_ACTIVE" ]]; then
    echo "$(date): Monitor $MONITOR_NAME is active but should be closed (Reload detected?). Disabling." >> "$LOG_FILE"
    hyprctl eval "hl.monitor({ output = \"$MONITOR_NAME\", disabled = true })"
    # hyprctl keyword monitor "$MONITOR_NAME,disable"
    LAST_STATE="closed"
  elif [[ "$TARGET_STATE" == "open" && -z "$IS_ACTIVE" ]]; then
    echo "$(date): Monitor $MONITOR_NAME is inactive but should be open. Enabling." >> "$LOG_FILE"
    # hyprctl keyword monitor "$MONITOR_NAME,preferred,auto,1"
    hyprctl eval "hl.monitor({ output = \"$MONITOR_NAME\", disabled = false })"
    # hyprctl dispatch dpms on "$MONITOR_NAME"
    LAST_STATE="open"
  fi

  sleep 1
done
