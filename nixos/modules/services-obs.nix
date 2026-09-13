{ pkgs, unstable, ... }:

{
  programs.obs-studio = {
    enable = true;
    package = unstable.obs-studio.override {
      cudaSupport = true;
    };
    enableVirtualCamera = true;
    plugins = with unstable.obs-studio-plugins; [
      wlrobs
      waveform
      obs-pipewire-audio-capture
      obs-gstreamer
      obs-vkcapture
      obs-backgroundremoval
      pixel-art
      obs-vertical-canvas
      obs-aitum-multistream
    ];
  };

  systemd.user.services.obs-stream-mode-monitor = {
    description = "Enable stream mode while OBS is running";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    path = with pkgs; [
      bash
      coreutils
      procps
      systemd
    ];

    serviceConfig = {
      ExecStart = "%h/.config/niri/scripts/obs-stream-mode-monitor.sh";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
