This directory contains the NixOS configuration tracked in this repository.

Current status:
- `hosts/saebyn-studio/` contains the active host configuration.
- `modules/` contains reusable NixOS modules for shared concerns.
- `hardware-configuration.nix` remains host-specific and machine-bound.

Notes:
- This tree is separate from the chezmoi-managed `home/` source state.
- The configuration currently imports `nixos-unstable` through the local Nix channel.
