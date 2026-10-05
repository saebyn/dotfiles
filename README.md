# dotfiles

Portable user configuration managed with chezmoi, plus host-specific NixOS configuration.

The `home/` tree remains the source of truth for chezmoi-managed user dotfiles.
The `nixos/` tree contains NixOS host configuration kept alongside those dotfiles.

## Layout

- `home/` contains chezmoi-managed source state.
- `.chezmoiroot` points chezmoi at `home/`.
- `nixos/` contains host-specific NixOS configuration and modules.

## Apply

```bash
chezmoi diff
chezmoi apply
```

## Kitty stream-mode sizing

Stream mode uses the shared Niri controller for both Mod+Shift+N and the OBS
monitor. Normal font size stays in `home/dot_config/kitty/kitty.conf` (10 pt);
adjust `STREAM_FONT_SIZE` in `home/dot_config/kitty/executable_stream-font-size.sh`
to change the proposed 14 pt stream default.

On a mode transition, existing Kitty processes reload their config and reset
all OS windows to the mode's default. New processes read `~/.stream-mode`
directly, including launches from shells with an old `STREAM_MODE` environment.
Ctrl+plus/minus still zoom manually; Ctrl+0 resets to the current mode's default.
Repeated `on` or `off` requests preserve manual zoom. Turning stream mode off
resets to the normal default, rather than restoring an earlier manual zoom.

Kitty uses a separate Unix socket per process under `$XDG_RUNTIME_DIR`, with
remote control restricted to sockets. **Restart existing Kitty processes once
after applying these dotfiles:** listening sockets cannot be enabled by config
reload. No Niri binding or OBS service changes are required. A failed Kitty
update reports a warning and does not block other instances or Waybar.

### Verification

Automated checks (Python standard library, Bash, and `flock`; no desktop needed):

```bash
python3 -m unittest discover -s tests -v
git diff --check
```

The tests check transitions, idempotency, concurrent toggles, multiple socket
targets, missing Kitty/runtime directory, failures, flag-based startup config,
manual mappings, Bash syntax, and the actual OBS monitor with mocked processes.
They do not parse configuration with Kitty or exercise its remote-control server.

On the Niri machine, after `chezmoi diff` and `chezmoi apply`:

1. Close OBS, turn stream mode off, and restart Kitty. Run `niri validate` and
   open Kitty's config debug view (Ctrl+Shift+F6) to check for config errors and
   the expected font size/socket settings. Confirm `$XDG_RUNTIME_DIR` is set and
   `ls "$XDG_RUNTIME_DIR"/kitty-stream-mode-*` shows per-process sockets.
2. Open two independent terminals with Mod+T and another OS window with
   Ctrl+Shift+N. Press Mod+Shift+N: all should increase to the stream default.
   Open another terminal with Mod+T; it should start at the larger size too.
3. Try Ctrl+plus/minus, then Ctrl+0: reset should return to the stream default.
   Zoom again and run `~/.config/niri/scripts/toggle-stream-mode.sh on` twice;
   the manual size should stay unchanged.
4. Press Mod+Shift+N to turn mode off: all windows, including those opened
   while streaming, should return to 10 pt. New independent and same-process
   windows should also use 10 pt. Check manual zoom/reset and repeated `off`.
5. With mode off, start OBS: within about a second, existing/new Kitty windows
   should use stream size. Close OBS: they should return to normal. Also start
   OBS after manually enabling mode; closing OBS should leave that manually
   owned mode active, as before.
6. Close all Kitty windows and toggle on/off to confirm stream mode and Waybar
   still work. Optionally launch `env STREAM_MODE=1 kitty` while mode is off,
   and `env -u STREAM_MODE kitty` while on: font size should follow the flag.
