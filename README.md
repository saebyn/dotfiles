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
