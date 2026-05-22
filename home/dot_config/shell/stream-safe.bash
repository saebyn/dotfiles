# Stream-safe shell mode
# See issue #6 (Add stream-safe shell mode)
# See issue #9 (Add stream-safe mode toggle via niri keybind with waybar indicator)
#
# Activated by Mod+Shift+N in niri, which writes ~/.stream-mode and sets
# STREAM_MODE=1 in the systemd user environment.
# The flag file is the source of truth since niri children don't re-read
# the systemd user environment after it changes.

# Sync STREAM_MODE from flag file if not already set in environment
if [[ -f "$HOME/.stream-mode" ]]; then
  export STREAM_MODE=1
else
  export STREAM_MODE=0
fi

# env-public: print environment variables with likely secrets filtered out
env-public() {
  env | grep -viE '(token|secret|key|password|auth|credential|private|api_|_api|passwd|cert|jwt)'
}

# Reminder tip when stream mode is active
if [[ "${STREAM_MODE}" == "1" ]]; then
  printf '🔴 STREAM MODE active: avoid cat .env; use env-public for environment inspection.\n'
fi
