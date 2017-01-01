{
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
	gcc6
	gdb
	gnumake
	gnupg1compat
	graphviz
	i7z
	idea.idea-community
	python27Packages.ipython
	jq
	kde4.kcachegrind
	kde4.ksnapshot
	leiningen
	libffi
	libnotify
	light
	macchanger
	minecraft
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
	python27Packages.pip
	python27Packages.pygame
	python27Packages.virtualenv
	python3
	rustc
	snes9x-gtk
	steam
	unzip
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
