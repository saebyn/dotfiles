# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  boot.loader.grub.extraEntries =
    ''
    menuentry "Windows 7" {
      chainloader (hd0,0)+1
    }

    menuentry "Gentoo Linux 3.12.20" {
      search --set=root --label GRUB --hint hd0,msdos2
      linux /boot/vmlinuz-3.12.20-gentoo root=/dev/sda4
    }
    '';

  hardware.bluetooth.enable = true;

  networking = {
    hostName = "fornax";
    nameservers = ["8.8.8.8" "8.8.4.4"];
    hostId = "6113a239";
    useDHCP = false;
    wicd.enable = true;
    wireless.enable = false;
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    terminus_font
    gitAndTools.gitFull
    tmux
    xfontsel
    xlsfonts
    xclip
    google-chrome
    vim
    rxvt_unicode
    dzen2
    dmenu2
    conky
    pamixer
    jre
    libreoffice
    gimp
    inkscape
    vlc
    tigervnc
    slock
    docker
    bmon
    file
    leiningen
    python27Full
    xsel
  ];

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      bluez = pkgs.bluez5;
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    videoDrivers = [ "nvidia" ];
    synaptics.enable = true;
    synaptics.twoFingerScroll = true;
    synaptics.palmDetect = true;
    synaptics.additionalOptions = ''
      Option "PalmMinWidth" "8"
    '';
    deviceSection = ''
      Option     "RegistryDwords" "PowerMizerEnable=0x1; PerfLevelSrc=0x3322; PowerMizerDefaultAC=0x1" 
    '';

    useGlamor = true;

    wacom.enable = true;

    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
    #windowManager.xmonad.extraPackages = self: [ self.xmonadContrib ];
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.socketActivation = false;
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "john" ];

  time.timeZone = "America/Los_Angeles";

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.opengl.driSupport32Bit = true;

  security.setuidPrograms = ["slock"];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.john = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker"];
    uid = 1000;
  };
}
