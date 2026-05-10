{ pkgs, unstable, ... }:

{
  users.users.saebyn = {
    isNormalUser = true;
    description = "saebyn";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "render"
      "plugdev"
      "audio"
    ];
    packages = with pkgs; [
      lmms
      pandoc
      lazygit
      musescore
      chezmoi
      pre-commit
      gitleaks
      fzf
      ripgrep
      fd
      curl
      clang
      unzip
      gnumake
      hydrogen
      unstable.opencode
      gh
      obsidian
      protonmail-desktop
      marksman
      unstable.blender
      godotPackages_4_6.godot
      discord
      aseprite
      audacity
      fontforge-gtk
      ardour
      keymapp
      prismlauncher
      nixfmt
      krita
      inkscape-with-extensions
      nodejs_24
      twitch-cli
      pnpm
      ungoogled-chromium
      awscli2
      jq
      biome
      prisma-engines
      android-studio
      kotlin
      ssm-session-manager-plugin
      starship
      fastfetch
      whisper-cpp
      vlc
      oterm
      swaynotificationcenter
      waybar
      fuzzel
      bzmenu
      kitty
      xwayland-satellite
      pavucontrol
      pamixer
      bluez
      bluez-tools
      networkmanager_dmenu
      mako
      libnotify
      nautilus
      typst
      davinci-resolve-studio
      javaPackages.compiler.temurin-bin.jdk-21
      rust-analyzer
      rustup
      (vscode.fhsWithPackages (
        ps: with ps; [
          rust-analyzer
          rustup
          kotlin
          pkgs.javaPackages.compiler.temurin-bin.jdk-21
          zlib
          openssl.dev
          pkg-config
          gcc
          gdtoolkit_4
        ]
      ))
    ];
  };
}
