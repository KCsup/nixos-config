{ pkgs, ... }:

{
  home.packages = [
    (pkgs.callPackage ../../modules/slippi {
      playbackSlippi = false;
    })

    pkgs.anytype

    pkgs.ventoy

    pkgs.fusee-interfacee-tk
  ];
}
