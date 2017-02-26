{
  allowBroken = true;
  allowUnfree = true;
  packageOverrides = pkgs_: with pkgs_; {
    all = with pkgs; buildEnv {
      name = "all";
      paths = [
        atom
        awscli
        bashCompletion
        bind
        blender
        cargo
        cm_unicode
        cmake
        corefonts
        ffmpeg
        file
        firefox
        dzen2
        dmenu2
        rxvt_unicode
        xclip
        conky
        pamixer
        terminus_font
        gitAndTools.gitFull
        tmux
        xfontsel
        xlsfonts
        gcc6
        gdb
        gnumake
        gnupg1compat
        graphviz
        i7z
        idea.idea-community
        python27Packages.ipython
        jq
        gimp
        kde4.kcachegrind
        kde4.ksnapshot
        leiningen
        libffi
        libnotify
        libreoffice
        light
        macchanger
        minecraft
        ncdu
        nodejs-6_x
        npm2nix
        notify-osd
        obs-studio
        octave
        openssl
        #oraclejdk
        patchelf
        psmisc
        deluge
        python27Packages.flake8
        python27Packages.virtualenv
        python3
        rustc
        snes9x-gtk
        steam
        unzip
        vagrant
        vim_configurable
        which
        winetricks
        wineFull
        wireshark-qt
        xorg.xauth
        xboxdrv
        xsel
        youtube-dl
        zeal
        zip
      ];
    };
  };
}
