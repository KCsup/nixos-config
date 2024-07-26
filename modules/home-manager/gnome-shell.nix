{ pkgs, ... }:

{
  home.packages = [
    # pkgs.pop-launcher
  ];

  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.forge; }
    ];
  };
}
