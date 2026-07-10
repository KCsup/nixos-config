{ pkgs, ... }:

{

    
  home.packages = [
    # disable Slippi install
    # broken as of 5/25/26
    # (pkgs.callPackage ../../modules/slippi {
    #   playbackSlippi = false;
    # })

    pkgs.anytype

    pkgs.ventoy

    pkgs.fusee-interfacee-tk

    pkgs.tailscale

    (pkgs.callPackage ./pkgs/saleae-logic-2.nix { })
  ];

  # Enables fractional scaling
  dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };
  };
}
