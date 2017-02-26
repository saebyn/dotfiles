#!/bin/sh

set -e

nix-channel --remove nixos
nix-channel --add http://nixos.org/channels/nixos-unstable nixos
nixos-rebuild switch --upgrade

# Cleanup any previous generations and delete old packa
nix-collect-garbage -d


sudo -u john sh -c 'cd /home/john; git clone https://github.com/saebyn/dotfiles.git; cd dotfiles; NIX_REMOTE=daemon ./install -v || true'
