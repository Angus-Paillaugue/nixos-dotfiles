#!/usr/bin/env bash

# Get list of keyboard names
keyboards=$(hyprctl devices -j | jq -r '.keyboards[].name')

# Loop and switch layout
for kbd in $keyboards; do
  hyprctl switchxkblayout "$kbd" next
done
