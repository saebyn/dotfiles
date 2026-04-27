# dotfiles

Portable user configuration managed with chezmoi.

This repo intentionally focuses on user-level dotfiles, not full system configuration.

## Layout

- `home/` contains chezmoi-managed source state.
- `.chezmoiroot` points chezmoi at `home/`.

## Apply

```bash
chezmoi diff
chezmoi apply
```
