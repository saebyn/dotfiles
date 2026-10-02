{ pkgs, unstable, ... }:

let
  xwayland-satellite_0_8_1 =
    let
      version = "0.8.1";
      src = pkgs.fetchFromGitHub {
        owner = "Supreeeme";
        repo = "xwayland-satellite";
        tag = "v${version}";
        hash = "sha256-BUE41HjLIGPjq3U8VXPjf8asH8GaMI7FYdgrIHKFMXA=";
      };
    in
    pkgs.xwayland-satellite.overrideAttrs (_: {
      inherit version src;
      cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
        inherit version src;
        pname = "xwayland-satellite";
        hash = "sha256-16L6gsvze+m7XCJlOA1lsPNELE3D364ef2FTdkh0rVY=";
      };
    });
in
{
  users.users.saebyn = {
    isNormalUser = true;
    description = "saebyn";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "input"
      "render"
      "plugdev"
      "audio"
    ];
    packages = with pkgs; [
      lmms
      pandoc
      lazygit
      git-lfs
      musescore
      rmpc
      chezmoi
      pre-commit
      gitleaks
      fzf
      mpvpaper
      ripgrep
      fd
      curl
      clang
      unzip
      gnumake
      hydrogen
      unstable.opencode
      gh
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
      (whisper-cpp.override {
        cudaSupport = true;
      })
      vlc
      oterm
      swaynotificationcenter
      waybar
      fuzzel
      bzmenu
      kitty
      # 0.8.2 hides Resolve's Project Manager: upstream issue #481.
      xwayland-satellite_0_8_1
      pavucontrol
      pamixer
      bluez
      bluez-tools
      networkmanager_dmenu
      mako
      libnotify
      nautilus
      typst
      unstable.davinci-resolve-studio
      javaPackages.compiler.temurin-bin.jdk-21
      rust-analyzer
      rustup
    ];
  };

  environment.variables = {
    PRISMA_QUERY_ENGINE_BINARY = "${unstable.prisma-engines_7}/bin/query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY = "${unstable.prisma-engines_7}/lib/libquery_engine.so";
    PRISMA_SCHEMA_ENGINE_BINARY = "${unstable.prisma-engines_7}/bin/schema-engine";
  };
}
