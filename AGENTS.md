# Agent Instructions

This repository contains portable user dotfiles managed with chezmoi.

## Repository layout

- `.chezmoiroot` points chezmoi at `home/`.
- `home/` contains chezmoi source state.
- `nixos/` contains NixOS system configuration, organized under `nixos/hosts/` and `nixos/modules/`.
- This repo manages both user-level dotfiles (via chezmoi) and NixOS system configuration.

## Tool usage

When inspecting files or running commands in OpenCode, use the available `bash` tool.
Do not call a tool named `run`.

Prefer read-only inspection commands before proposing edits:
- `pwd`
- `git status --short`
- `find . -maxdepth 3 -type f | sort`
- `git diff --stat`
- `chezmoi diff`

## Safety rules

- Do not modify files unless explicitly asked.
- Before editing, explain the proposed change and the exact files affected.
- Keep the repo focused and low-cruft.
- Do not add secrets, tokens, auth files, browser profiles, caches, generated application state, or private keys.
- Assume tools are installed through NixOS configuration, not temporary `nix shell` usage.

## Project goal

The current migration goal is moving from VS Code + GitHub Copilot to Neovim + local AI.

Neovim currently starts from a clean LazyVim baseline under `home/dot_config/nvim`.
