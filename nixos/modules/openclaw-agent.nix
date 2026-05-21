{ pkgs, unstable, ... }:

let
  openclawUser = "openclaw-agent";
  openclawGroup = "openclaw-agent";
  openclawHome = "/var/lib/openclaw-agent";
  openclawGateway = pkgs.writeShellScript "openclaw-gateway" ''
    set -euo pipefail
    
    export HOME=${openclawHome}
    export DOCKER_HOST="unix:///''${XDG_RUNTIME_DIR}/docker.sock"
    exec ${unstable.openclaw}/bin/openclaw gateway --port 18789
  '';
in
{
  users.groups.${openclawGroup} = {};
  users.users.${openclawUser} = {
    isSystemUser = true;
    group = openclawGroup;
    home = openclawHome;
    createHome = true;
    shell = pkgs.bashInteractive;

    # Ensure that systemd services that run as this user are not killed when
    # the user logs out.
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

    # Explicitly set extraGroups to an empty list to prevent the user from being added
    # to the docker group, which would allow it to run arbitrary containers and
    # potentially escape the sandbox.
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

  systemd.user.services.openclaw-gateway = {
    enable = true;
    description = "OpenClaw Gateway";
    after = [ "docker.target" ];
    wants = [ "docker.target" ];
    wantedBy = [ "default.target" ];

    path = [
      pkgs.docker
      pkgs.coreutils
      pkgs.bash
      unstable.openclaw
    ];

    unitConfig = {
      ConditionUser = openclawUser;
    };

    serviceConfig = {
      User = openclawUser;
      Group = openclawGroup;
      WorkingDirectory = openclawHome;
      EnvironmentFile = [
        "%h/.openclaw/discord.env"
      ];
      ExecStart = "${openclawGateway}";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
