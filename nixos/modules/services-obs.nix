{ unstable, ... }:

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
}
