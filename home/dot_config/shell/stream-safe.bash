# Stream-safe shell mode
# See issue #6 (Add stream-safe shell mode)
# See issue #9 (Add stream-safe mode toggle via niri keybind with waybar indicator)
#
# Enable by setting STREAM_MODE=1 (done automatically via systemd user environment
# when toggled with Mod+Shift+T in niri).

# env-public: print environment variables with likely secrets filtered out
env-public() {
  env | grep -viE '(token|secret|key|password|auth|credential|private|api_|_api|passwd|cert|jwt)'
}

# Reminder tip when stream mode is active
if [[ "${STREAM_MODE:-0}" == "1" ]]; then
  printf '🔴 STREAM MODE active: avoid cat .env; use env-public for environment inspection.\n'
fi
