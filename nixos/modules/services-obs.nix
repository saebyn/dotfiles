{ localPkgs, ... }:

{
  programs.obs-studio = {
    enable = true;
    package = localPkgs.obs-studio.override {
      cudaSupport = true;
    };
    enableVirtualCamera = true;
    plugins = with localPkgs.obs-studio-plugins; [
      wlrobs
      waveform
      obs-pipewire-audio-capture
      obs-gstreamer
      obs-vkcapture
      obs-backgroundremoval
      pixel-art
      obs-localvocal
    ];
  };
}
