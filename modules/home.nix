{ config, pkgs, lib, user, ... }:

let
  background-image-path = "file:///home/${user}/.nixconf/modules/home-manager/garf.png";
in
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

    # (pkgs.callPackage ./slippi {
    #   playbackSlippi = false;
    # })
    
    pkgs.steam-run

    pkgs.bitwarden-desktop
    pkgs.bitwarden-cli

    pkgs.devbox

    pkgs.qbittorrent
    pkgs.vlc

    pkgs.spotify

    pkgs.htop

    (let
      pname = "rustlings";
      version = "6.1.0";
    in
    pkgs.rustPlatform.buildRustPackage {
      inherit pname version;

      src = pkgs.fetchCrate {
        inherit pname version;
        sha256 = "sha256-vzZbj9Ouaa4hplfqLi2ZdTuVc5s+RONgjQNWv/h9PKM=";
      };

      cargoSha256 = "sha256-Pj+BWKgF/WIHlVq6AqHluI2+BTNhc81o1TCODZaPNxI=";

      nativeBuildInputs = [ pkgs.pkg-config ];
    })

    pkgs.protonvpn-gui
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    ".config/awesome" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/${user}/.nixconf/dotfiles/awesome";
      # recursive = true;
    };
    
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

  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" = {
      switch-windows = [ "<Alt>Tab" ];
      switch-applications = [ "" ];
    };

    "org/gnome/desktop/background" = {
      picture-uri = background-image-path;
      picture-uri-dark = background-image-path;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
