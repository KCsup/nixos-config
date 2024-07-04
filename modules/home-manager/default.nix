{ pkgs, ... }:

{
  imports = map (n: "${./common}/${n}") (builtins.attrNames (builtins.readDir ./common));
  home.packages = [
    pkgs.firefox
    pkgs.discord-ptb

    pkgs.pika-backup

    pkgs.p7zip

    (pkgs.callPackage ../slippi {
      playbackSlippi = false;
    })
  ];

  home.sessionVariables = {
    EDITOR = "hx";
    SUDO_EDITOR = "hx";
  };
}
