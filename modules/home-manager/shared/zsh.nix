{ config, pkgs, hostName, ... }:

{
  home.packages = [
    pkgs.neofetch
    pkgs.thefuck
    pkgs.zoxide
    pkgs.zellij
    pkgs.eza
  ];
  
  programs.zsh = {
    enable = true;
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ~/.nixconf#${hostName}";
      ls = "eza";
      cd = "z";
      sr = "sudo reboot";
      ssn = "sudo shutdown now";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
      theme = "eastwood";
    };
    initExtra = ''
      neofetch
      eval "$(zoxide init zsh)"
    '';
  };

  programs.bat = {
    enable = true;

    config = {
      theme = "gruvbox-dark";
    };
  };
}
