{ ... }:

{
  systemd.services.local-data-manager = {
    enable = true;
    description = "Local Data Manager";
    after = [ "local-fs-pre.target" ];
    serviceConfig = {
      Type = "forking";
      User = "root";
      ExecStart = "/run/current-system/sw/bin/ldmtool create all";
      Restart = "on-failure";
      Environment = "PATH=/run/current-system/sw/bin:/usr/bin:/bin";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
