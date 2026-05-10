{ pkgs, unstable, ... }:

let
  openclawUser = "openclaw-agent";
  openclawGroup = "openclaw-agent";
  openclawHome = "/var/lib/openclaw-agent";
in
{
  users.groups.${openclawGroup} = {};
  users.users.${openclawUser} = {
    isSystemUser = true;
    group = openclawGroup;
    home = openclawHome;
    createHome = true;
    shell = pkgs.bashInteractive;

    #
    linger = true;

    subUidRanges = [
      {
        startUid = 200000;
        count = 65536;
      }
    ];

    subGidRanges = [
      {
        startGid = 200000;
        count = 65536;
      }
    ];

    extraGroups = [];

    packages = with pkgs; [
      unstable.openclaw
    ];
  };

  systemd.tmpfiles.rules = [
    "d ${openclawHome} 0700 ${openclawUser} ${openclawGroup} -"
    "d ${openclawHome}/workspace 0700 ${openclawUser} ${openclawGroup} -"
    "d ${openclawHome}/secrets 0700 ${openclawUser} ${openclawGroup} -"
  ];
}
