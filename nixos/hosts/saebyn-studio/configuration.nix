{ ... }:

let
  localPkgs = import /home/saebyn/Documents/MyRepos/nixpkgs { };
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
    };
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/desktop.nix
    ../../modules/nvidia.nix
    ../../modules/audio.nix
    ../../modules/printing.nix
    ../../modules/packages-system.nix
    ../../modules/user-saebyn.nix
    ../../modules/services-ai.nix
    ../../modules/services-obs.nix
    ../../modules/virtualization.nix
    ../../modules/local-data-manager.nix
  ];

  _module.args = {
    inherit localPkgs unstable;
  };

  networking.hostName = "saebyn-studio";

  system.stateVersion = "25.05";
}
