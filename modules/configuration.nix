# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, inputs, user, isWSL, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      inputs.home-manager.nixosModules.default
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = !isWSL;
  boot.loader.grub.enable = !isWSL;
  boot.loader.grub.efiSupport = !isWSL;
  boot.loader.grub.device = lib.mkIf (!isWSL) "nodev";
  boot.loader.efi.canTouchEfiVariables = !isWSL;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = !isWSL;

  # Set your time zone.
  time.timeZone = "America/Detroit";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };


  services.xserver = lib.mkIf (!isWSL) {
    enable = true;

    # displayManager = {
    #   sddm.enable = true;
    #   defaultSession = "none+awesome";
    # };

    # windowManager.awesome = {
    #   enable = true;
    #   luaModules = with pkgs.luaPackages; [
    #     luarocks # is the package manager for Lua modules
    #     # luadbi-mysql # Database abstraction layer
    #   ];
    # };

    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = !isWSL;

  # Enable sound with pipewire.
  sound.enable = !isWSL;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = !isWSL;
  services.pipewire = lib.mkIf (!isWSL) {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  users.defaultUserShell = pkgs.zsh;
  environment.shells = [ pkgs.zsh ];
  programs.zsh.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = "Josh Fernandez";
    extraGroups = [ "networkmanager" "wheel" ];
    # packages = with pkgs; [
    #   firefox
    #   discord-ptb
    # #  thunderbird
    # ];
  };

  # home-manager = {
  #   extraSpecialArgs = { inherit inputs; };
  #   users = {
  #     "josh" = import ./home.nix;
  #   };

  #   useGlobalPkgs = true;
  #   useUserPackages = true;
  # };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # nixpkgs.overlays = [
  #   (final: prev: {
  #     slippi = prev.callPackage ./applications/slippi { };
  #   })
  # ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

    # gnomeExtensions.pop-shell # Only works with GNOME installed!

  #  wget
  ];

  services.udev.extraRules = lib.mkIf (!isWSL) ''
    ${builtins.readFile ./slippi/udev/51-gcadapter.rules}
    ${builtins.readFile ./slippi/udev/51-losslessadapter.rules}
  '';

  # environment.etc = {
  #   "udev/rules.d/51-gcadapter.rules".source = dotfiles/slippi/51-gcadapter.rules;
  #   "udev/rules.d/51-losslessadapter.rules".source = dotfiles/slippi/51-losslessadapter.rules;
  # };

  # services.udev.packages = [
  #   (pkgs.writeTextFile {
  #     name = "51-gcadapter.rules";
  #     text = (builtins.readFile ./dotfiles/slippi/51-gcadapter.rules);
  #     destination = "/etc/udev/rules.d/51-gcadapter.rules";
  #   })

  #   (pkgs.writeTextFile {
  #     name = "51-losslessadapter.rules";
  #     text = (builtins.readFile ./dotfiles/slippi/51-losslessadapter.rules);
  #     destination = "/etc/udev/rules.d/51-losslessadapter.rules";
  #   })

  # ];
  boot.extraModulePackages = lib.mkIf (!isWSL) [ 
    config.boot.kernelPackages.gcadapter-oc-kmod
  ];

  # to autoload at boot:
  boot.kernelModules = lib.mkIf (!isWSL) [ 
    "gcadapter_oc"
  ];
  boot.kernelParams = lib.mkIf (!isWSL) [ "gcadapter_oc.rate=1" ];

  # programs.gnupg.agent = {
  #   enable = true;
  #   pinentryPackage = pkgs.pinentry-curses;
  #   enableSSHSupport = true;
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
