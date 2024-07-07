{ pkgs, ... }:

{
  home.packages = [
    pkgs.pinentry-curses
  ];
  
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };
}
