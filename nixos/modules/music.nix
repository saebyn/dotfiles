{ pkgs, ... }:

{
  services.mpd = {
    enable = true;
    user = "saebyn";
    group = "users";
    dataDir = "/home/saebyn/.local/share/mpd";
    settings = {
      bind_to_address = "127.0.0.1";
      music_directory = "/home/saebyn/Music";
      playlist_directory = "/home/saebyn/.local/share/mpd/playlists";

      audio_output = [
        {
          type = "pipewire";
          name = "PipeWire";
        }
      ];
    };
  };

  systemd.services.mpd = {
    environment = {
      XDG_RUNTIME_DIR = "/run/user/1000";
    };

    preStart = ''
      ${pkgs.coreutils}/bin/install -d -m 0755 -o saebyn -g users \
        /home/saebyn/.local/share/mpd/playlists
    '';
  };
}
