#!/usr/bin/env bash
# toggle-stream-mode.sh — toggle STREAM_MODE in the systemd user environment
# and signal waybar to refresh.
# Bound to Mod+Shift+N in niri (issue #9).

set -euo pipefail

FLAG_FILE="$HOME/.stream-mode"

action="${1:-toggle}"

if [[ "$action" == "toggle" ]]; then
	if [[ -f "$FLAG_FILE" ]]; then
		action="off"
	else
		action="on"
	fi
fi

case "$action" in
on)
	touch "$FLAG_FILE"
	systemctl --user set-environment STREAM_MODE=1 || true
	;;
off)
	rm -f "$FLAG_FILE"
	systemctl --user unset-environment STREAM_MODE || true
	;;
*)
	printf 'Usage: %s [on|off|toggle]\n' "$0" >&2
	exit 2
	;;
esac

# Signal waybar to refresh custom modules (signal 1 = SIGRTMIN+1)
pkill -SIGRTMIN+1 waybar 2>/dev/null || true
