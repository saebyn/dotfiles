This directory stages the NixOS configuration for migration into the dotfiles repo.

Current status:
- `hosts/saebyn-studio/` contains copies of the active host config.
- Root-level `configuration.nix` and `hardware-configuration.nix` remain untouched.

Planned next steps:
- Move this `nixos/` directory into the dotfiles repository.
- Point `/etc/nixos/configuration.nix` at `hosts/saebyn-studio/configuration.nix`.
- Split the monolithic configuration into reusable modules.
