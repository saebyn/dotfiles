#!/usr/bin/env bash
# Single setting for the stream-mode font size (points). Normal size is in kitty.conf.
STREAM_FONT_SIZE=14.0

if [[ -f "$HOME/.stream-mode" ]]; then
	printf 'font_size %s\n' "$STREAM_FONT_SIZE"
fi
# An inactive stream produces no override, but must still exit successfully.
exit 0
