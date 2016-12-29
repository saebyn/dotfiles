{ config, pkgs, ... }:

{

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    terminus_font
    gitAndTools.gitFull
    tmux
    xfontsel
    xlsfonts
    xclip
    firefox
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
    vagrant
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

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    synaptics.enable = true;
    synaptics.twoFingerScroll = true;
    synaptics.palmDetect = true;
    synaptics.additionalOptions = ''
      Option "PalmMinWidth" "8"
    '';
    useGlamor = true;

    wacom.enable = true;

    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
    #windowManager.xmonad.extraPackages = self: [ self.xmonadContrib ];
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.socketActivation = false;

  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };


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
