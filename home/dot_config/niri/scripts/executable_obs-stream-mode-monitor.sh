#!/usr/bin/env bash

set -euo pipefail

FLAG_FILE="$HOME/.stream-mode"
OWNER_FILE="$HOME/.stream-mode.obs-owned"
CONTROLLER="$HOME/.config/niri/scripts/toggle-stream-mode.sh"

obs_is_running() {
	pgrep -f '(^|/)obs([[:space:]]|$)' >/dev/null
}

shutdown() {
	if [[ -f "$OWNER_FILE" ]]; then
		"$CONTROLLER" off
		rm -f "$OWNER_FILE"
	fi
	exit 0
}

trap shutdown INT TERM

while true; do
	if obs_is_running; then
		if [[ ! -f "$FLAG_FILE" && ! -f "$OWNER_FILE" ]]; then
			touch "$OWNER_FILE"
			"$CONTROLLER" on
		elif [[ -f "$OWNER_FILE" && ! -f "$FLAG_FILE" ]]; then
			"$CONTROLLER" on
		fi
	elif [[ -f "$OWNER_FILE" ]]; then
		"$CONTROLLER" off
		rm -f "$OWNER_FILE"
	fi

	sleep 1
done
