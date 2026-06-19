{ ... }:

let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "openclaw-2026.6.1"
      ];
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
    ../../modules/music.nix
    ../../modules/printing.nix
    ../../modules/packages-system.nix
    ../../modules/user-saebyn.nix
    ../../modules/services-ai.nix
    ../../modules/services-obs.nix
    ../../modules/virtualization.nix
    ../../modules/local-data-manager.nix
    ../../modules/openclaw-agent.nix
  ];

  _module.args = {
    inherit unstable;
  };

  networking.hostName = "saebyn-studio";

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 64 * 1024; # 64 GB
    }
  ];

  system.stateVersion = "25.05";
}
