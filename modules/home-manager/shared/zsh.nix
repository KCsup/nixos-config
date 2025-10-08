{ config, pkgs, hostName, ... }:

{
  home.packages = [
    pkgs.fastfetch
    pkgs.thefuck
    pkgs.zoxide
    # pkgs.zellij
    pkgs.eza
    pkgs.unzrip
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
      unzip = "unzrip";

      # pico util
      pico-init = "git clone https://github.com/raspberrypi/pico-sdk.git --branch master; cd pico-sdk; git submodule update --init; cd ..";
      pico-init-examples = "git clone https://github.com/raspberrypi/pico-examples.git --branch master";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
      theme = "eastwood-custom";
    };
    initExtra = ''
      if ! [[ -n $IN_NIX_SHELL ]]; then
        fastfetch
      fi

      export SHELL=zsh
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

  programs.zellij = {
    enable = true;

    # enableZshIntegration = true;
    # settings = {
    #   default_shell = "zsh";
    # };
    # extraConfig = ''
    #   default_shell "zsh"
    # '';
  };
}
