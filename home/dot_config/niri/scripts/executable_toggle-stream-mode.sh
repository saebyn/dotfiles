#!/usr/bin/env bash
# toggle-stream-mode.sh — toggle STREAM_MODE in the systemd user environment
# update Kitty font sizes and signal waybar to refresh.
# Bound to Mod+Shift+N in niri (issue #9).

set -euo pipefail

FLAG_FILE="$HOME/.stream-mode"

# Serialize manual and OBS-driven transitions, including their Kitty updates.
exec 9>"$HOME/.stream-mode.lock"
flock 9

previous="off"
[[ ! -f "$FLAG_FILE" ]] || previous="on"

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

# Only reset zoom on a transition. Repeated on/off calls preserve manual zoom.
# Reload the mode-dependent default before resetting all OS windows and the
# default for future OS windows in each already-running Kitty process.
if [[ "$action" != "$previous" ]] && command -v kitty >/dev/null && [[ -n "${XDG_RUNTIME_DIR:-}" ]]; then
	for socket in "$XDG_RUNTIME_DIR"/kitty-stream-mode-*; do
		[[ -S "$socket" ]] || continue
		if ! kitty @ --to "unix:$socket" load-config ||
			! kitty @ --to "unix:$socket" set-font-size --all 0; then
			printf 'Could not update Kitty stream-mode font size via %s\n' "$socket" >&2
		fi
	done
fi

# Signal waybar to refresh custom modules (signal 1 = SIGRTMIN+1)
pkill -SIGRTMIN+1 waybar 2>/dev/null || true
