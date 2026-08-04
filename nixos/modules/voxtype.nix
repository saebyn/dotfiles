{ unstable, ... }:

let
  package = unstable.voxtype-vulkan;
in
{
  environment.systemPackages = [ package ];

  systemd.user.services.voxtype = {
    description = "Voxtype voice dictation";

    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [
      "graphical-session.target"
      "pipewire.service"
      "pipewire-pulse.service"
    ];

    serviceConfig = {
      ExecStart = "${package}/bin/voxtype daemon";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
