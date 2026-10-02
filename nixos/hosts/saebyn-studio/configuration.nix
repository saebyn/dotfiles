{ lib, ... }:

let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "openclaw-2026.6.33"
      ];
    };
  };
  redeemfx = builtins.fetchTarball {
    url = "https://github.com/saebyn/redeemfx/archive/777ece95b012f4f22f050f46867f9e4135a04f5c.tar.gz";
    sha256 = "1f1x320dlnc1p6gqsvvkd4zbhaa2vrnp3s8ry2i4c7vjwnhh8c0f";
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/desktop.nix
    ../../modules/nvidia.nix
    ../../modules/audio.nix
    ../../modules/voxtype.nix
    ../../modules/music.nix
    ../../modules/printing.nix
    ../../modules/packages-system.nix
    ../../modules/user-saebyn.nix
    ../../modules/services-ai.nix
    ../../modules/services-obs.nix
    ../../modules/gtnh-control.nix
    ../../modules/virtualization.nix
    ../../modules/work-drives.nix
    ../../modules/openclaw-agent.nix
    "${redeemfx}/nix/module.nix"
  ]
  ++ lib.optional (builtins.pathExists ./redeemfx-local.nix) ./redeemfx-local.nix;

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
