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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.john = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker" "vagrant"];
    uid = 1001;
    password = "vagrant";
  };

  users.extraUsers.vagrant = {
    uid = 1000;
  };
}
