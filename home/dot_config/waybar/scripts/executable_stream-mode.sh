#!/usr/bin/env bash
# stream-mode.sh — waybar custom module for stream mode indicator
# Returns JSON for waybar. Empty text when inactive.

FLAG_FILE="$HOME/.stream-mode"

if [[ -f "$FLAG_FILE" ]]; then
  printf '{"text": "🔴 STREAM", "tooltip": "Stream mode active (Mod+Shift+N to toggle)", "class": "stream-active"}\n'
else
  printf '{"text": "", "tooltip": ""}\n'
fi
