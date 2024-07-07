{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.neofetch
    pkgs.thefuck
    pkgs.zoxide
    pkgs.zellij
    pkgs.eza
    pkgs.bat
  ];
  
  programs.zsh = {
    enable = true;
    shellAliases = {
      update-framework = "sudo nixos-rebuild switch --flake ~/.nixconf#framework";
      update-wsl = "sudo nixos-rebuild switch --flake ~/.nixconf#wsl";
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
}
