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
      shlvl = "echo $SHLVL";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
      theme = "eastwood-custom";
    };
    initExtra = ''
      neofetch
      eval "$(zoxide init zsh)"

      dev() {
        if [[ $# != 1 ]]; then
          printf '%s\n' "''${(%):-%F{red\}}Supply one arg.''${(%):-%f}"
        else
          nix develop $HOME/.nixconf#$1 --impure --command "zsh"
        fi
      }
    '';
    sessionVariables = {
      ZSH_CUSTOM = "$HOME/.nixconf/modules/zsh-custom";
    };
  };

  programs.bat = {
    enable = true;

    config = {
      theme = "gruvbox-dark";
    };
  };
}
