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

  # Enables fractional scaling
  dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };
  };
}
