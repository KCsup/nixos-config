{ config, pkgs, ... }:

let
  modulesDir = ../../modules;
in
{
  imports = [
    "${modulesDir}/home-manager"
  ];
  

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "josh";
  home.homeDirectory = "/home/josh";

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
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # pkgs.firefox
    # pkgs.discord-ptb

    pkgs.pass
    pkgs.wl-clipboard # Required for pass's password copy feature

    pkgs.gparted

    # pkgs.pika-backup

    # pkgs.p7zip

    # pkgs.appimage-run

    
    # # (pkgs.callPackage ./applications/slippi-launcher {})
    # (pkgs.callPackage ./applications/slippi {
    #   playbackSlippi=false;
    # })
    # # (pkgs.callPackage ./applications/slippi {
    # #   playbackSlippi=true;
    # # })
    
    # pkgs.steam-run
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
  #
  # home.sessionVariables = {
  #   EDITOR = "hx";
  #   SUDO_EDITOR = "hx";
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
