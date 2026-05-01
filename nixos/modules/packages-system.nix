{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tree-sitter
    lua-language-server
    shfmt
    stylua
    nil
    ffmpeg-full
    wget
    pciutils
    git
    ldmtool
    cups-brother-hl3170cdw
    hack-font
    fira-code
    nerd-fonts.hack
    nerd-fonts.fira-code
    (python3.withPackages (
      ps: with ps; [
        requests
        virtualenv
        pip
        boto3
      ]
    ))
  ];
}
