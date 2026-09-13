{ ... }:

{
  fileSystems."/home/saebyn/Work" = {
    device = "/dev/disk/by-uuid/1fa9a85d-1585-4260-89a3-3461b23c6bc7";
    fsType = "ext4";
  };

  fileSystems."/home/saebyn/Media" = {
    device = "/dev/disk/by-uuid/9bb6602f-eb49-4099-a0c1-8037ab76b1e7";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  fileSystems."/home/saebyn/Scratch" = {
    device = "/dev/disk/by-uuid/1d354508-92d5-4153-8415-d4de9435924e";
    fsType = "ext4";
    options = [ "noatime" ];
  };
}
