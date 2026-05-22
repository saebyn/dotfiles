#!/usr/bin/env bash
# toggle-stream-mode.sh — toggle STREAM_MODE in the systemd user environment
# and signal waybar to refresh.
# Bound to Mod+Shift+T in niri (issue #9).

set -euo pipefail

FLAG_FILE="$HOME/.stream-mode"

if [[ -f "$FLAG_FILE" ]]; then
  # Turn off
  rm -f "$FLAG_FILE"
  systemctl --user unset-environment STREAM_MODE
else
  # Turn on
  touch "$FLAG_FILE"
  systemctl --user set-environment STREAM_MODE=1
fi

# Signal waybar to refresh custom modules (signal 1 = SIGRTMIN+1)
pkill -SIGRTMIN+1 waybar 2>/dev/null || true
