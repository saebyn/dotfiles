#!/usr/bin/env bash
WALLPAPER="$HOME/Videos/wallpaper.mp4"
if [ -f "$WALLPAPER" ]; then
  exec mpvpaper -o "loop=inf" DP-1 "$WALLPAPER" &
fi
