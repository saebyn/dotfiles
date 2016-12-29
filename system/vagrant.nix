{ config, pkgs, ... }:

{
  imports =
    [
      /home/john/dotfiles/system/common.nix
    ];

  virtualisation.virtualbox.guest.enable = true;
  services.openssh.enable = true;

  services.xserver = {
    videoDrivers = [ "virtualbox" ];
  };

  users.extraUsers.john = {
    uid = 1000;
    password = "vagrant";
  };

  users.extraUsers.vagrant = {
    uid = 1001;
  };
}
