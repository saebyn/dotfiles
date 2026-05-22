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
      unstable.pnpm
      ungoogled-chromium
      awscli2
      jq
      biome
      unstable.prisma-engines_7
      unstable.prisma_7
      openssl
      android-studio
      kotlin
      ssm-session-manager-plugin
      starship
      fastfetch
      # CLI quality-of-life tools (issue #7)
      zoxide
      direnv
      nix-direnv
      bat
      eza
      delta
      duf
      dust
      btop
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

  environment.variables = {
    PRISMA_QUERY_ENGINE_BINARY = "${unstable.prisma-engines_7}/bin/query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY = "${unstable.prisma-engines_7}/lib/libquery_engine.so";
    PRISMA_SCHEMA_ENGINE_BINARY = "${unstable.prisma-engines_7}/bin/schema-engine";
  };
}
