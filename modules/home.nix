{ config, pkgs, user, ... }:

{
  imports = map (n: "${./home-manager/shared}/${n}") (builtins.attrNames (builtins.readDir ./home-manager/shared));
  

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.

  home.packages = [
    pkgs.firefox
    pkgs.discord-ptb


    pkgs.gparted

    pkgs.pika-backup

    pkgs.p7zip

    (pkgs.callPackage ./slippi {
      playbackSlippi = false;
    })
    
    pkgs.steam-run

    pkgs.bitwarden-desktop
    pkgs.bitwarden-cli
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # ".config/awesome/".source = dotfiles/awesome;
    # ".config/cava/".source = dotfiles/cava;
    # ".config/mpd/".source = dotfiles/mpd;
    # ".config/mpDris2".source = dotfiles/mpDris2;
    # ".config/ncmpcpp".source = dotfiles/ncmpcpp;
    # ".config/picom/".source = dotfiles/picom;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/josh/etc/profile.d/hm-session-vars.sh
  
  home.sessionVariables = {
    EDITOR = "hx";
    SUDO_EDITOR = "hx";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
