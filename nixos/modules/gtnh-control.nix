{ pkgs, ... }:

let
  repository = "/home/saebyn/Documents/MyRepos/gtnh-control";
  world = "/home/saebyn/gtnh-server/mc-data/world";
in
{
  systemd.services.gtnh-layout-snapshot = {
    description = "Generate a timestamped GTNH base layout snapshot";

    serviceConfig = {
      Type = "oneshot";
      User = "saebyn";
      WorkingDirectory = repository;
      ExecStart = "${pkgs.python3}/bin/python3 ${repository}/tools/snapshot_base_layout.py --world ${world}";
      Nice = 10;
      IOSchedulingClass = "idle";
      UMask = "0022";
    };
  };

  systemd.timers.gtnh-layout-snapshot = {
    description = "Generate the daily GTNH base layout snapshot";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "*-*-* 04:30:00";
      Persistent = true;
      Unit = "gtnh-layout-snapshot.service";
    };
  };
}
