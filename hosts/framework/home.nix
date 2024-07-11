{ pkgs, ... }:

{
  home.packages = [
    (pkgs.callPackage ../../modules/slippi {
      playbackSlippi = false;
    })
  ];
}
